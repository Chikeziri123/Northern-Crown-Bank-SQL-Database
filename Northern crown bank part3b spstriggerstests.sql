USE Northern_Crown_Bank
GO

CREATE PROCEDURE sp_OpenAccount
    @customer_id INT,
    @account_type_id INT,
    @branch_id INT,
    @initial_deposit DECIMAL(15,2) = 0.00,
    @overdraft_limit DECIMAL(10,2) = 0.00
AS
BEGIN
    SET NOCOUNT ON

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customer_id = @customer_id AND is_active = 1)
    BEGIN
        RAISERROR('Customer not found or is inactive.', 16, 1)
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Account_Types WHERE account_type_id = @account_type_id AND is_active = 1)
    BEGIN
        RAISERROR('Account type not found or unavailable.', 16, 1)
        RETURN
    END

    DECLARE @min_balance DECIMAL(10,2)
    SELECT @min_balance = min_opening_balance FROM Account_Types WHERE account_type_id = @account_type_id

    IF @initial_deposit < @min_balance
    BEGIN
        RAISERROR('Initial deposit does not meet minimum opening balance requirement.', 16, 1)
        RETURN
    END

    DECLARE @account_number VARCHAR(8)
    SET @account_number = RIGHT('00000000' + CAST((SELECT ISNULL(MAX(CAST(account_number AS INT)), 10001000) + 1 FROM Accounts) AS VARCHAR), 8)

    INSERT INTO Accounts (account_number, customer_id, account_type_id, branch_id, balance, overdraft_limit)
    VALUES (@account_number, @customer_id, @account_type_id, @branch_id, @initial_deposit, @overdraft_limit)

    DECLARE @account_id INT
    SET @account_id = SCOPE_IDENTITY()

    IF @initial_deposit > 0
    BEGIN
        INSERT INTO Transactions (account_id, transaction_type, amount, balance_after, description, channel)
        VALUES (@account_id, 'Deposit', @initial_deposit, @initial_deposit, 'Initial account deposit', 'Branch')
    END

    INSERT INTO Audit_Log (table_name, record_id, action_type, action_description)
    VALUES ('Accounts', @account_id, 'INSERT', 
            'New account opened: ' + @account_number + ' for customer ID ' + CAST(@customer_id AS VARCHAR))

    PRINT 'Account opened successfully. Account Number: ' + @account_number
END
GO

CREATE PROCEDURE sp_TransferFunds
    @from_account_id INT,
    @to_account_id INT,
    @amount DECIMAL(12,2),
    @description VARCHAR(255) = 'Fund transfer',
    @channel VARCHAR(20) = 'Online'
AS
BEGIN
    SET NOCOUNT ON

    IF @amount <= 0
    BEGIN
        RAISERROR('Transfer amount must be greater than zero.', 16, 1)
        RETURN
    END

    DECLARE @from_balance DECIMAL(15,2)
    DECLARE @from_overdraft DECIMAL(10,2)
    DECLARE @to_balance DECIMAL(15,2)

    SELECT @from_balance = balance, @from_overdraft = overdraft_limit 
    FROM Accounts WHERE account_id = @from_account_id AND status = 'Active'

    IF @from_balance IS NULL
    BEGIN
        RAISERROR('Source account not found or inactive.', 16, 1)
        RETURN
    END

    SELECT @to_balance = balance 
    FROM Accounts WHERE account_id = @to_account_id AND status = 'Active'

    IF @to_balance IS NULL
    BEGIN
        RAISERROR('Destination account not found or inactive.', 16, 1)
        RETURN
    END

    IF (@from_balance - @amount) < -@from_overdraft
    BEGIN
        RAISERROR('Insufficient funds. Transfer would exceed overdraft limit.', 16, 1)
        RETURN
    END

    BEGIN TRANSACTION

    UPDATE Accounts SET balance = balance - @amount, last_transaction_date = CAST(GETDATE() AS DATE), updated_date = GETDATE()
    WHERE account_id = @from_account_id

    UPDATE Accounts SET balance = balance + @amount, last_transaction_date = CAST(GETDATE() AS DATE), updated_date = GETDATE()
    WHERE account_id = @to_account_id

    DECLARE @new_from_balance DECIMAL(15,2)
    DECLARE @new_to_balance DECIMAL(15,2)
    SELECT @new_from_balance = balance FROM Accounts WHERE account_id = @from_account_id
    SELECT @new_to_balance = balance FROM Accounts WHERE account_id = @to_account_id

    INSERT INTO Transactions (account_id, transaction_type, amount, balance_after, description, channel, related_account_id)
    VALUES (@from_account_id, 'Transfer Out', @amount, @new_from_balance, @description, @channel, @to_account_id)

    INSERT INTO Transactions (account_id, transaction_type, amount, balance_after, description, channel, related_account_id)
    VALUES (@to_account_id, 'Transfer In', @amount, @new_to_balance, 'Transfer received: ' + @description, @channel, @from_account_id)

    COMMIT TRANSACTION

    INSERT INTO Audit_Log (table_name, record_id, action_type, action_description)
    VALUES ('Transactions', @from_account_id, 'INSERT', 
            'Transfer of ' + CAST(@amount AS VARCHAR) + ' from account ' + CAST(@from_account_id AS VARCHAR) + 
            ' to account ' + CAST(@to_account_id AS VARCHAR))

    PRINT 'Transfer completed successfully.'
END
GO

CREATE PROCEDURE sp_BlockCard
    @card_id INT,
    @reason VARCHAR(20),
    @raise_fraud_alert BIT = 0
AS
BEGIN
    SET NOCOUNT ON

    IF NOT EXISTS (SELECT 1 FROM Cards WHERE card_id = @card_id AND status = 'Active')
    BEGIN
        RAISERROR('Card not found or already inactive.', 16, 1)
        RETURN
    END

    UPDATE Cards SET status = @reason, updated_date = GETDATE()
    WHERE card_id = @card_id

    IF @raise_fraud_alert = 1
    BEGIN
        DECLARE @account_id INT
        SELECT @account_id = account_id FROM Cards WHERE card_id = @card_id

        INSERT INTO Fraud_Alerts (account_id, card_id, alert_type, severity, description, investigation_status)
        VALUES (@account_id, @card_id, 
                CASE @reason WHEN 'Stolen' THEN 'Account Takeover' ELSE 'Card Not Present' END,
                'High',
                'Card reported as ' + @reason + '. Fraud alert raised automatically. Card ID: ' + CAST(@card_id AS VARCHAR),
                'Open')
    END

    INSERT INTO Audit_Log (table_name, record_id, action_type, action_description)
    VALUES ('Cards', @card_id, 'UPDATE', 'Card blocked. Reason: ' + @reason)

    PRINT 'Card blocked successfully. Status set to: ' + @reason
END
GO

CREATE PROCEDURE sp_MonthlyStatement
    @account_id INT,
    @statement_year INT,
    @statement_month INT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @start_date DATE
    DECLARE @end_date DATE
    SET @start_date = DATEFROMPARTS(@statement_year, @statement_month, 1)
    SET @end_date = EOMONTH(@start_date)

    DECLARE @customer_name VARCHAR(100)
    DECLARE @account_number VARCHAR(8)
    DECLARE @account_type VARCHAR(50)

    SELECT 
        @customer_name = c.first_name + ' ' + c.last_name,
        @account_number = a.account_number,
        @account_type = at.type_name
    FROM Accounts a
    INNER JOIN Customers c ON a.customer_id = c.customer_id
    INNER JOIN Account_Types at ON a.account_type_id = at.account_type_id
    WHERE a.account_id = @account_id

    IF @customer_name IS NULL
    BEGIN
        RAISERROR('Account not found.', 16, 1)
        RETURN
    END

    PRINT '============================================'
    PRINT 'NORTHERN CROWN BANK'
    PRINT 'MONTHLY ACCOUNT STATEMENT'
    PRINT '============================================'
    PRINT 'Customer: ' + @customer_name
    PRINT 'Account:  ' + @account_number
    PRINT 'Type:     ' + @account_type
    PRINT 'Period:   ' + CAST(@start_date AS VARCHAR) + ' to ' + CAST(@end_date AS VARCHAR)
    PRINT '============================================'

    SELECT 
        transaction_date, transaction_time, transaction_type, description,
        CASE WHEN transaction_type IN ('Deposit', 'Transfer In', 'Interest Credit', 'Refund') 
            THEN amount ELSE NULL END AS credit,
        CASE WHEN transaction_type NOT IN ('Deposit', 'Transfer In', 'Interest Credit', 'Refund') 
            THEN amount ELSE NULL END AS debit,
        balance_after
    FROM Transactions
    WHERE account_id = @account_id AND transaction_date BETWEEN @start_date AND @end_date
    ORDER BY transaction_date, transaction_time

    SELECT 
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN transaction_type IN ('Deposit', 'Transfer In', 'Interest Credit', 'Refund') THEN amount ELSE 0 END) AS total_credits,
        SUM(CASE WHEN transaction_type NOT IN ('Deposit', 'Transfer In', 'Interest Credit', 'Refund') THEN amount ELSE 0 END) AS total_debits
    FROM Transactions
    WHERE account_id = @account_id AND transaction_date BETWEEN @start_date AND @end_date

    PRINT 'END OF STATEMENT'
END
GO

CREATE PROCEDURE sp_BankPerformanceReport
    @report_year INT,
    @report_month INT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @start_date DATE
    DECLARE @end_date DATE
    SET @start_date = DATEFROMPARTS(@report_year, @report_month, 1)
    SET @end_date = EOMONTH(@start_date)

    PRINT '============================================'
    PRINT 'NORTHERN CROWN BANK - PERFORMANCE REPORT'
    PRINT 'Period: ' + CAST(@start_date AS VARCHAR) + ' to ' + CAST(@end_date AS VARCHAR)
    PRINT '============================================'

    PRINT '--- TRANSACTION SUMMARY ---'
    SELECT COUNT(*) AS total_transactions, SUM(amount) AS total_value,
        AVG(amount) AS avg_transaction, COUNT(DISTINCT account_id) AS active_accounts
    FROM Transactions
    WHERE transaction_date BETWEEN @start_date AND @end_date AND status = 'Completed'

    PRINT '--- CHANNEL BREAKDOWN ---'
    SELECT channel, COUNT(*) AS transactions, SUM(amount) AS total_value
    FROM Transactions
    WHERE transaction_date BETWEEN @start_date AND @end_date
    GROUP BY channel ORDER BY transactions DESC

    PRINT '--- LOAN PERFORMANCE ---'
    SELECT COUNT(*) AS active_loans, SUM(outstanding_balance) AS total_outstanding,
        SUM(missed_payments) AS total_missed_payments, AVG(interest_rate) AS avg_interest_rate
    FROM Loans WHERE status = 'Active'

    PRINT '--- FRAUD SUMMARY ---'
    SELECT COUNT(*) AS total_alerts,
        SUM(CASE WHEN investigation_status = 'Resolved' THEN 1 ELSE 0 END) AS resolved,
        SUM(CASE WHEN investigation_status IN ('Open', 'Under Review', 'Escalated') THEN 1 ELSE 0 END) AS open_cases,
        SUM(CASE WHEN severity IN ('High', 'Critical') THEN 1 ELSE 0 END) AS high_severity
    FROM Fraud_Alerts
    WHERE alert_date BETWEEN @start_date AND @end_date

    PRINT 'END OF REPORT'
END
GO

-- TRIGGERS


CREATE TRIGGER trg_AuditCustomerUpdate
ON Customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO Audit_Log (table_name, record_id, action_type, action_description)
    SELECT 'Customers', i.customer_id, 'UPDATE',
        'Customer record updated: ' + i.first_name + ' ' + i.last_name
    FROM inserted i

    UPDATE c SET updated_date = GETDATE()
    FROM Customers c INNER JOIN inserted i ON c.customer_id = i.customer_id
END
GO

CREATE TRIGGER trg_FlagLargeTransaction
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO Fraud_Alerts (account_id, transaction_id, alert_type, severity, description, investigation_status)
    SELECT i.account_id, i.transaction_id, 'Large Withdrawal', 'Medium',
        'Transaction of ' + CAST(i.amount AS VARCHAR) + ' flagged. Type: ' + i.transaction_type + '. ' + i.description,
        'Open'
    FROM inserted i
    WHERE i.amount >= 5000
        AND i.transaction_type IN ('Withdrawal', 'Transfer Out', 'Card Payment', 'Online Payment')
END
GO

CREATE TRIGGER trg_AuditAccountStatusChange
ON Accounts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO Audit_Log (table_name, record_id, action_type, action_description)
    SELECT 'Accounts', i.account_id, 'UPDATE',
        'Account ' + i.account_number + ' status changed from ' + d.status + ' to ' + i.status
    FROM inserted i
    INNER JOIN deleted d ON i.account_id = d.account_id
    WHERE i.status <> d.status
END
GO

-- DML OPERATIONS

UPDATE Customers SET phone_number = '07799001122' WHERE customer_id = 1
GO

UPDATE Customers SET credit_score = 745 WHERE customer_id = 1
GO

UPDATE Loan_Repayments 
SET status = 'Paid', repayment_amount = 222.75, repayment_date = '2024-12-15', days_late = 14
WHERE repayment_id = 6 AND status = 'Missed'
GO

UPDATE Fraud_Alerts 
SET investigation_status = 'Resolved', resolved_date = GETDATE(), 
    resolution_notes = 'Customer verified transaction. Location mismatch due to VPN usage.'
WHERE alert_id = 3
GO

IF EXISTS (SELECT 1 FROM Standing_Orders WHERE standing_order_id = 7 AND status = 'Completed')
BEGIN
    DELETE FROM Standing_Orders WHERE standing_order_id = 7
    PRINT 'Completed standing order removed.'
END
ELSE
BEGIN
    PRINT 'Standing order not found or not Completed. No deletion performed.'
END
GO

-- EXECUTE STORED PROCEDURES (Testing)

EXEC sp_OpenAccount @customer_id = 2, @account_type_id = 3, @branch_id = 1,
    @initial_deposit = 500.00, @overdraft_limit = 0.00
GO

EXEC sp_TransferFunds @from_account_id = 1, @to_account_id = 2,
    @amount = 250.00, @description = 'Monthly savings transfer', @channel = 'Mobile'
GO

EXEC sp_BlockCard @card_id = 12, @reason = 'Lost', @raise_fraud_alert = 0
GO

EXEC sp_MonthlyStatement @account_id = 1, @statement_year = 2024, @statement_month = 10
GO

EXEC sp_BankPerformanceReport @report_year = 2024, @report_month = 10
GO

SELECT * FROM Audit_Log ORDER BY action_date DESC
GO
