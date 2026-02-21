CREATE DATABASE Northern_Crown_Bank
GO

USE Northern_Crown_Bank
GO

-- TABLE 1: Branches
-- Stores details of all bank branches across the UK
CREATE TABLE Branches (
    branch_id           INT IDENTITY(1,1) PRIMARY KEY,
    branch_name         VARCHAR(100) NOT NULL UNIQUE,
    address_line1       VARCHAR(100) NOT NULL,
    address_line2       VARCHAR(100) NULL,
    city                VARCHAR(50) NOT NULL,
    postcode            VARCHAR(10) NOT NULL,
    phone_number        VARCHAR(20) NOT NULL,
    manager_name        VARCHAR(100) NULL,
    opening_date        DATE NOT NULL,
    is_active           BIT NOT NULL DEFAULT 1,
    created_date        DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- ============================================================================
-- TABLE 2: Staff
-- Stores information about all bank employees
-- ============================================================================
CREATE TABLE Staff (
    staff_id            INT IDENTITY(1,1) PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    job_role            VARCHAR(50) NOT NULL
                        CHECK (job_role IN ('Branch Manager', 'Relationship Manager', 'Teller', 
                               'Loan Officer', 'Fraud Analyst', 'Customer Service', 'Compliance Officer', 'Admin')),
    branch_id           INT NOT NULL,
    email               VARCHAR(100) NOT NULL UNIQUE,
    phone_number        VARCHAR(20) NULL,
    hire_date           DATE NOT NULL,
    is_active           BIT NOT NULL DEFAULT 1,
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    updated_date        DATETIME NULL,
    CONSTRAINT FK_Staff_Branch FOREIGN KEY (branch_id)
        REFERENCES Branches(branch_id)
)
GO

CREATE NONCLUSTERED INDEX IX_Staff_Role ON Staff(job_role)
CREATE NONCLUSTERED INDEX IX_Staff_Branch ON Staff(branch_id)
GO

-- ============================================================================
-- TABLE 3: Customers
-- Stores customer personal details and KYC information
-- ============================================================================
CREATE TABLE Customers (
    customer_id         INT IDENTITY(1,1) PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    date_of_birth       DATE NOT NULL,
    gender              VARCHAR(20) NOT NULL
                        CHECK (gender IN ('Male', 'Female', 'Non-Binary', 'Prefer Not to Say')),
    national_insurance  VARCHAR(9) NOT NULL UNIQUE,
    address_line1       VARCHAR(100) NOT NULL,
    address_line2       VARCHAR(100) NULL,
    city                VARCHAR(50) NOT NULL,
    postcode            VARCHAR(10) NOT NULL,
    phone_number        VARCHAR(20) NOT NULL,
    email               VARCHAR(100) NULL,
    employment_status   VARCHAR(30) NOT NULL DEFAULT 'Employed'
                        CHECK (employment_status IN ('Employed', 'Self-Employed', 'Unemployed', 'Retired', 'Student')),
    annual_income       DECIMAL(12,2) NULL,
    credit_score        INT NULL CHECK (credit_score BETWEEN 0 AND 999),
    kyc_verified        BIT NOT NULL DEFAULT 0,
    home_branch_id      INT NULL,
    registration_date   DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    is_active           BIT NOT NULL DEFAULT 1,
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    updated_date        DATETIME NULL,
    CONSTRAINT FK_Customer_Branch FOREIGN KEY (home_branch_id)
        REFERENCES Branches(branch_id),
    CONSTRAINT CK_Customer_DOB CHECK (date_of_birth <= DATEADD(YEAR, -16, GETDATE()))
)
GO

CREATE NONCLUSTERED INDEX IX_Customer_LastName ON Customers(last_name, first_name)
CREATE NONCLUSTERED INDEX IX_Customer_Postcode ON Customers(postcode)
CREATE NONCLUSTERED INDEX IX_Customer_Branch ON Customers(home_branch_id)
CREATE NONCLUSTERED INDEX IX_Customer_CreditScore ON Customers(credit_score)
GO

-- ============================================================================
-- TABLE 4: Account_Types
-- Reference table for available account products
-- ============================================================================
CREATE TABLE Account_Types (
    account_type_id     INT IDENTITY(1,1) PRIMARY KEY,
    type_name           VARCHAR(50) NOT NULL UNIQUE,
    category            VARCHAR(30) NOT NULL
                        CHECK (category IN ('Current', 'Savings', 'ISA', 'Fixed Deposit', 'Student', 'Junior')),
    interest_rate       DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    monthly_fee         DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    overdraft_available BIT NOT NULL DEFAULT 0,
    min_opening_balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    description         VARCHAR(255) NULL,
    is_active           BIT NOT NULL DEFAULT 1,
    created_date        DATETIME NOT NULL DEFAULT GETDATE()
)
GO

-- ============================================================================
-- TABLE 5: Accounts
-- Stores all customer bank accounts
-- ============================================================================
CREATE TABLE Accounts (
    account_id          INT IDENTITY(1,1) PRIMARY KEY,
    account_number      VARCHAR(8) NOT NULL UNIQUE,
    sort_code           VARCHAR(8) NOT NULL DEFAULT '20-45-67',
    customer_id         INT NOT NULL,
    account_type_id     INT NOT NULL,
    branch_id           INT NOT NULL,
    balance             DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    overdraft_limit     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    opening_date        DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    status              VARCHAR(20) NOT NULL DEFAULT 'Active'
                        CHECK (status IN ('Active', 'Dormant', 'Frozen', 'Closed')),
    last_transaction_date DATE NULL,
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    updated_date        DATETIME NULL,
    CONSTRAINT FK_Account_Customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT FK_Account_Type FOREIGN KEY (account_type_id)
        REFERENCES Account_Types(account_type_id),
    CONSTRAINT FK_Account_Branch FOREIGN KEY (branch_id)
        REFERENCES Branches(branch_id),
    CONSTRAINT CK_Account_Number CHECK (LEN(account_number) = 8),
    CONSTRAINT CK_Overdraft CHECK (overdraft_limit >= 0)
)
GO

CREATE NONCLUSTERED INDEX IX_Account_Customer ON Accounts(customer_id)
CREATE NONCLUSTERED INDEX IX_Account_Status ON Accounts(status)
CREATE NONCLUSTERED INDEX IX_Account_Type ON Accounts(account_type_id)
GO

-- ============================================================================
-- TABLE 6: Transactions
-- Records all financial transactions across accounts
-- ============================================================================
CREATE TABLE Transactions (
    transaction_id      INT IDENTITY(1,1) PRIMARY KEY,
    account_id          INT NOT NULL,
    transaction_type    VARCHAR(30) NOT NULL
                        CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer In', 'Transfer Out',
                               'Direct Debit', 'Standing Order', 'Card Payment', 'Contactless', 
                               'Online Payment', 'Interest Credit', 'Fee Charge', 'Refund')),
    amount              DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    balance_after       DECIMAL(15,2) NOT NULL,
    transaction_date    DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    transaction_time    TIME NOT NULL DEFAULT CAST(GETDATE() AS TIME),
    description         VARCHAR(255) NOT NULL,
    reference_number    VARCHAR(20) NULL,
    channel             VARCHAR(20) NOT NULL DEFAULT 'Online'
                        CHECK (channel IN ('Online', 'Mobile', 'Branch', 'ATM', 'Phone', 'Auto')),
    related_account_id  INT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'Completed'
                        CHECK (status IN ('Completed', 'Pending', 'Failed', 'Reversed')),
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Trans_Account FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id),
    CONSTRAINT FK_Trans_RelatedAccount FOREIGN KEY (related_account_id)
        REFERENCES Accounts(account_id)
)
GO

CREATE NONCLUSTERED INDEX IX_Trans_Account ON Transactions(account_id)
CREATE NONCLUSTERED INDEX IX_Trans_Date ON Transactions(transaction_date)
CREATE NONCLUSTERED INDEX IX_Trans_Type ON Transactions(transaction_type)
CREATE NONCLUSTERED INDEX IX_Trans_Status ON Transactions(status)
GO


SELECT name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('Transactions') AND definition LIKE '%channel%'
GO

ALTER TABLE Transactions DROP CONSTRAINT CK__Transacti__chann__7E37BEF6
GO

ALTER TABLE Transactions ADD CONSTRAINT CK_Trans_Channel 
CHECK (channel IN ('Online', 'Mobile', 'Branch', 'ATM', 'Phone', 'Auto', 'Contactless'))
GO

SELECT * FROM Transactions;


-- ============================================================================
-- TABLE 7: Cards
-- Stores debit and credit card details linked to accounts
-- ============================================================================
CREATE TABLE Cards (
    card_id             INT IDENTITY(1,1) PRIMARY KEY,
    account_id          INT NOT NULL,
    customer_id         INT NOT NULL,
    card_type           VARCHAR(20) NOT NULL
                        CHECK (card_type IN ('Debit', 'Credit', 'Prepaid')),
    card_number_last4   VARCHAR(4) NOT NULL CHECK (LEN(card_number_last4) = 4),
    expiry_date         DATE NOT NULL,
    daily_limit         DECIMAL(10,2) NOT NULL DEFAULT 500.00,
    contactless_enabled BIT NOT NULL DEFAULT 1,
    status              VARCHAR(20) NOT NULL DEFAULT 'Active'
                        CHECK (status IN ('Active', 'Blocked', 'Expired', 'Cancelled', 'Lost', 'Stolen')),
    issue_date          DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    updated_date        DATETIME NULL,
    CONSTRAINT FK_Card_Account FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id),
    CONSTRAINT FK_Card_Customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
)
GO


CREATE NONCLUSTERED INDEX IX_Card_Account ON Cards(account_id)
CREATE NONCLUSTERED INDEX IX_Card_Customer ON Cards(customer_id)
CREATE NONCLUSTERED INDEX IX_Card_Status ON Cards(status)
GO

-- TABLE 8: Loans
-- Stores all loan products issued to customers
CREATE TABLE Loans (
    loan_id             INT IDENTITY(1,1) PRIMARY KEY,
    customer_id         INT NOT NULL,
    account_id          INT NOT NULL,
    loan_officer_id     INT NOT NULL,
    loan_type           VARCHAR(30) NOT NULL
                        CHECK (loan_type IN ('Personal', 'Mortgage', 'Car Finance', 'Overdraft', 'Credit Builder')),
    principal_amount    DECIMAL(15,2) NOT NULL CHECK (principal_amount > 0),
    interest_rate       DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0),
    term_months         INT NOT NULL CHECK (term_months > 0),
    monthly_repayment   DECIMAL(10,2) NOT NULL,
    outstanding_balance DECIMAL(15,2) NOT NULL,
    start_date          DATE NOT NULL,
    end_date            DATE NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'Active'
                        CHECK (status IN ('Active', 'Paid Off', 'Defaulted', 'Restructured', 'Pending Approval')),
    missed_payments     INT NOT NULL DEFAULT 0,
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    updated_date        DATETIME NULL,
    CONSTRAINT FK_Loan_Customer FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT FK_Loan_Account FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id),
    CONSTRAINT FK_Loan_Officer FOREIGN KEY (loan_officer_id)
        REFERENCES Staff(staff_id),
    CONSTRAINT CK_Loan_Dates CHECK (end_date > start_date)
)
GO

CREATE NONCLUSTERED INDEX IX_Loan_Customer ON Loans(customer_id)
CREATE NONCLUSTERED INDEX IX_Loan_Status ON Loans(status)
CREATE NONCLUSTERED INDEX IX_Loan_Type ON Loans(loan_type)
GO

-- TABLE 9: Loan_Repayments
-- Tracks individual repayment records against loans
CREATE TABLE Loan_Repayments (
    repayment_id        INT IDENTITY(1,1) PRIMARY KEY,
    loan_id             INT NOT NULL,
    account_id          INT NOT NULL,
    repayment_amount    DECIMAL(10,2) NOT NULL CHECK (repayment_amount > 0),
    principal_portion   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    interest_portion    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    repayment_date      DATE NOT NULL,
    due_date            DATE NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'Paid'
                        CHECK (status IN ('Paid', 'Missed', 'Late', 'Partial')),
    days_late           INT NOT NULL DEFAULT 0,
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Repay_Loan FOREIGN KEY (loan_id)
        REFERENCES Loans(loan_id),
    CONSTRAINT FK_Repay_Account FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
)
GO

CREATE NONCLUSTERED INDEX IX_Repay_Loan ON Loan_Repayments(loan_id)
CREATE NONCLUSTERED INDEX IX_Repay_Date ON Loan_Repayments(repayment_date)
CREATE NONCLUSTERED INDEX IX_Repay_Status ON Loan_Repayments(status)
GO


-- Find exact constraint name
SELECT name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('Loan_Repayments') AND definition LIKE '%repayment_amount%'
GO

-- Drop and recreate allowing zero
ALTER TABLE Loan_Repayments DROP CONSTRAINT CK__Loan_Repa__repay__1332DBDC
GO

ALTER TABLE Loan_Repayments ADD CONSTRAINT CK_Repay_Amount 
CHECK (repayment_amount >= 0)
GO


-- TABLE 10: Standing_Orders
-- Manages recurring payments set up by customers
CREATE TABLE Standing_Orders (
    standing_order_id   INT IDENTITY(1,1) PRIMARY KEY,
    account_id          INT NOT NULL,
    payee_name          VARCHAR(100) NOT NULL,
    payee_account       VARCHAR(8) NULL,
    payee_sort_code     VARCHAR(8) NULL,
    amount              DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    frequency           VARCHAR(20) NOT NULL
                        CHECK (frequency IN ('Weekly', 'Monthly', 'Quarterly', 'Annually')),
    start_date          DATE NOT NULL,
    end_date            DATE NULL,
    next_payment_date   DATE NOT NULL,
    reference           VARCHAR(50) NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'Active'
                        CHECK (status IN ('Active', 'Paused', 'Cancelled', 'Completed')),
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_SO_Account FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
)
GO

CREATE NONCLUSTERED INDEX IX_SO_Account ON Standing_Orders(account_id)
CREATE NONCLUSTERED INDEX IX_SO_NextPayment ON Standing_Orders(next_payment_date)
GO

-- TABLE 11: Fraud_Alerts
-- Records suspected fraudulent activity for investigation
CREATE TABLE Fraud_Alerts (
    alert_id            INT IDENTITY(1,1) PRIMARY KEY,
    account_id          INT NOT NULL,
    transaction_id      INT NULL,
    card_id             INT NULL,
    alert_type          VARCHAR(50) NOT NULL
                        CHECK (alert_type IN ('Unusual Transaction', 'Location Mismatch', 'Rapid Spending',
                               'Large Withdrawal', 'Card Not Present', 'Multiple Failed Logins', 
                               'Account Takeover', 'Identity Theft')),
    severity            VARCHAR(10) NOT NULL DEFAULT 'Medium'
                        CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
    description         VARCHAR(500) NOT NULL,
    investigation_status VARCHAR(20) NOT NULL DEFAULT 'Open'
                        CHECK (investigation_status IN ('Open', 'Under Review', 'Escalated', 'Resolved', 'False Positive')),
    assigned_to         INT NULL,
    alert_date          DATETIME NOT NULL DEFAULT GETDATE(),
    resolved_date       DATETIME NULL,
    resolution_notes    VARCHAR(500) NULL,
    created_date        DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Fraud_Account FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id),
    CONSTRAINT FK_Fraud_Transaction FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id),
    CONSTRAINT FK_Fraud_Card FOREIGN KEY (card_id)
        REFERENCES Cards(card_id),
    CONSTRAINT FK_Fraud_Staff FOREIGN KEY (assigned_to)
        REFERENCES Staff(staff_id)
)
GO

CREATE NONCLUSTERED INDEX IX_Fraud_Account ON Fraud_Alerts(account_id)
CREATE NONCLUSTERED INDEX IX_Fraud_Status ON Fraud_Alerts(investigation_status)
CREATE NONCLUSTERED INDEX IX_Fraud_Severity ON Fraud_Alerts(severity)
CREATE NONCLUSTERED INDEX IX_Fraud_Date ON Fraud_Alerts(alert_date)
GO

-- TABLE 12: Audit_Log
-- Tracks important changes across the system for compliance
CREATE TABLE Audit_Log (
    log_id              INT IDENTITY(1,1) PRIMARY KEY,
    table_name          VARCHAR(50) NOT NULL,
    record_id           INT NOT NULL,
    action_type         VARCHAR(10) NOT NULL CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE')),
    action_description  VARCHAR(500) NOT NULL,
    performed_by        VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    action_date         DATETIME NOT NULL DEFAULT GETDATE()
)
GO

CREATE NONCLUSTERED INDEX IX_Audit_Table ON Audit_Log(table_name, action_date)
GO

