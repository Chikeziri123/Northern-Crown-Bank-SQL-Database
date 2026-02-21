USE Northern_Crown_Bank
GO


-- QUERY 1: List all active customers ordered by surname
SELECT 
    customer_id, first_name, last_name, city, postcode,
    employment_status, annual_income, credit_score, registration_date
FROM Customers
WHERE is_active = 1
ORDER BY last_name, first_name
GO

-- QUERY 2: All staff with their branch and role
SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    s.job_role, b.branch_name, b.city, s.hire_date
FROM Staff s
INNER JOIN Branches b ON s.branch_id = b.branch_id
WHERE s.is_active = 1
ORDER BY b.branch_name, s.last_name
GO

-- QUERY 3: All accounts with customer and account type details
SELECT 
    a.account_number, a.sort_code,
    c.first_name + ' ' + c.last_name AS customer_name,
    at.type_name, at.category, a.balance, a.overdraft_limit,
    a.status, b.branch_name, a.opening_date
FROM Accounts a
INNER JOIN Customers c ON a.customer_id = c.customer_id
INNER JOIN Account_Types at ON a.account_type_id = at.account_type_id
INNER JOIN Branches b ON a.branch_id = b.branch_id
WHERE a.status = 'Active'
ORDER BY c.last_name, at.category
GO

-- QUERY 4: Transactions for a specific customer in October 2024
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    a.account_number, t.transaction_type, t.amount, t.balance_after,
    t.transaction_date, t.transaction_time, t.description, t.channel, t.status
FROM Transactions t
INNER JOIN Accounts a ON t.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id
WHERE c.last_name = 'Henderson'
    AND t.transaction_date BETWEEN '2024-10-01' AND '2024-10-31'
ORDER BY t.transaction_date, t.transaction_time
GO

-- QUERY 5: All active cards with customer and account details
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    cd.card_type, '****-****-****-' + cd.card_number_last4 AS masked_card,
    a.account_number, at.type_name AS account_type,
    cd.daily_limit, cd.contactless_enabled, cd.expiry_date, cd.status
FROM Cards cd
INNER JOIN Accounts a ON cd.account_id = a.account_id
INNER JOIN Customers c ON cd.customer_id = c.customer_id
INNER JOIN Account_Types at ON a.account_type_id = at.account_type_id
WHERE cd.status = 'Active'
ORDER BY c.last_name, cd.card_type
GO

-- QUERY 6: All active loans with customer and officer details
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    l.loan_type, l.principal_amount, l.interest_rate, l.term_months,
    l.monthly_repayment, l.outstanding_balance, l.missed_payments,
    s.first_name + ' ' + s.last_name AS loan_officer,
    l.start_date, l.end_date, l.status
FROM Loans l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN Staff s ON l.loan_officer_id = s.staff_id
WHERE l.status = 'Active'
ORDER BY l.outstanding_balance DESC
GO

-- QUERY 7: Standing orders by customer
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    a.account_number, so.payee_name, so.amount, so.frequency,
    so.next_payment_date, so.reference, so.status
FROM Standing_Orders so
INNER JOIN Accounts a ON so.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id
WHERE so.status = 'Active'
ORDER BY c.last_name, so.next_payment_date
GO

-- QUERY 8: All fraud alerts ordered by severity
SELECT 
    fa.alert_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    a.account_number, fa.alert_type, fa.severity, fa.description,
    fa.investigation_status,
    s.first_name + ' ' + s.last_name AS assigned_analyst,
    fa.alert_date, fa.resolved_date, fa.resolution_notes
FROM Fraud_Alerts fa
INNER JOIN Accounts a ON fa.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id
LEFT JOIN Staff s ON fa.assigned_to = s.staff_id
ORDER BY 
    CASE fa.severity WHEN 'Critical' THEN 1 WHEN 'High' THEN 2 WHEN 'Medium' THEN 3 WHEN 'Low' THEN 4 END,
    fa.alert_date DESC
GO

-- QUERY 9: Loan repayment history with payment status
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    l.loan_type, lr.repayment_amount, lr.principal_portion, lr.interest_portion,
    lr.repayment_date, lr.due_date, lr.status, lr.days_late
FROM Loan_Repayments lr
INNER JOIN Loans l ON lr.loan_id = l.loan_id
INNER JOIN Customers c ON l.customer_id = c.customer_id
ORDER BY c.last_name, lr.due_date
GO

-- QUERY 10: Customers with credit scores below 600 (risk watch)
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.credit_score, c.employment_status, c.annual_income, c.city,
    b.branch_name AS home_branch,
    (SELECT COUNT(*) FROM Loans l WHERE l.customer_id = c.customer_id AND l.status = 'Active') AS active_loans,
    (SELECT SUM(l.outstanding_balance) FROM Loans l WHERE l.customer_id = c.customer_id AND l.status = 'Active') AS total_debt
FROM Customers c
LEFT JOIN Branches b ON c.home_branch_id = b.branch_id
WHERE c.credit_score < 600
ORDER BY c.credit_score
GO


-- QUERY 11: Monthly transaction volumes and values
SELECT 
    CONVERT(CHAR(7), transaction_date, 126) AS month,
    COUNT(*) AS total_transactions, SUM(amount) AS total_value,
    AVG(amount) AS avg_transaction, MAX(amount) AS largest_transaction,
    COUNT(DISTINCT account_id) AS active_accounts
FROM Transactions
WHERE transaction_date BETWEEN '2024-10-01' AND '2024-12-31'
GROUP BY CONVERT(CHAR(7), transaction_date, 126)
ORDER BY month
GO

-- QUERY 12: Transaction breakdown by type
SELECT 
    transaction_type, COUNT(*) AS transaction_count,
    SUM(amount) AS total_value, AVG(amount) AS avg_value,
    MIN(amount) AS min_value, MAX(amount) AS max_value
FROM Transactions
WHERE status = 'Completed'
GROUP BY transaction_type
ORDER BY total_value DESC
GO

-- QUERY 13: Branch performance - total deposits and accounts
SELECT 
    b.branch_name, b.city,
    COUNT(DISTINCT a.account_id) AS total_accounts,
    COUNT(DISTINCT a.customer_id) AS total_customers,
    SUM(a.balance) AS total_balances, AVG(a.balance) AS avg_balance
FROM Branches b
INNER JOIN Accounts a ON b.branch_id = a.branch_id
WHERE a.status = 'Active'
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_balances DESC
GO

-- QUERY 14: Transaction channel analysis
SELECT 
    channel, COUNT(*) AS transaction_count, SUM(amount) AS total_value,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Transactions) AS DECIMAL(5,2)) AS pct_of_total,
    AVG(amount) AS avg_value
FROM Transactions
WHERE status = 'Completed'
GROUP BY channel
ORDER BY transaction_count DESC
GO

-- QUERY 15: Customer income band distribution
SELECT 
    CASE 
        WHEN annual_income < 15000 THEN 'Under 15k'
        WHEN annual_income BETWEEN 15000 AND 30000 THEN '15k-30k'
        WHEN annual_income BETWEEN 30001 AND 50000 THEN '30k-50k'
        WHEN annual_income BETWEEN 50001 AND 75000 THEN '50k-75k'
        ELSE 'Over 75k'
    END AS income_band,
    COUNT(*) AS customer_count, AVG(credit_score) AS avg_credit_score,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customers) AS DECIMAL(5,2)) AS percentage
FROM Customers
GROUP BY 
    CASE 
        WHEN annual_income < 15000 THEN 'Under 15k'
        WHEN annual_income BETWEEN 15000 AND 30000 THEN '15k-30k'
        WHEN annual_income BETWEEN 30001 AND 50000 THEN '30k-50k'
        WHEN annual_income BETWEEN 50001 AND 75000 THEN '50k-75k'
        ELSE 'Over 75k'
    END
ORDER BY income_band
GO


-- QUERY 16: CTE - Customer total portfolio value
WITH CustomerPortfolio AS (
    SELECT 
        c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
        c.credit_score, c.annual_income,
        COUNT(a.account_id) AS total_accounts,
        SUM(a.balance) AS total_balance,
        SUM(a.overdraft_limit) AS total_overdraft_available
    FROM Customers c
    INNER JOIN Accounts a ON c.customer_id = a.customer_id
    WHERE a.status = 'Active'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.credit_score, c.annual_income
)
SELECT 
    customer_name, total_accounts, total_balance, total_overdraft_available,
    credit_score, annual_income,
    CAST(total_balance / NULLIF(annual_income, 0) * 100 AS DECIMAL(5,2)) AS savings_to_income_pct
FROM CustomerPortfolio
ORDER BY total_balance DESC
GO

-- QUERY 17: CTE - Loan risk analysis
WITH LoanRisk AS (
    SELECT 
        l.loan_id, c.first_name + ' ' + c.last_name AS customer_name,
        c.credit_score, l.loan_type, l.principal_amount,
        l.outstanding_balance, l.interest_rate, l.missed_payments,
        CASE 
            WHEN l.missed_payments >= 3 THEN 'High Risk'
            WHEN l.missed_payments >= 1 THEN 'Medium Risk'
            WHEN c.credit_score < 600 THEN 'Watch List'
            ELSE 'Low Risk'
        END AS risk_category
    FROM Loans l
    INNER JOIN Customers c ON l.customer_id = c.customer_id
    WHERE l.status = 'Active'
)
SELECT 
    risk_category, COUNT(*) AS loan_count,
    SUM(outstanding_balance) AS total_exposure,
    AVG(interest_rate) AS avg_interest_rate,
    AVG(credit_score) AS avg_credit_score,
    SUM(missed_payments) AS total_missed_payments
FROM LoanRisk
GROUP BY risk_category
ORDER BY 
    CASE risk_category WHEN 'High Risk' THEN 1 WHEN 'Medium Risk' THEN 2 WHEN 'Watch List' THEN 3 ELSE 4 END
GO

-- QUERY 18: Window Function - Rank customers by total balance per branch
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name, b.branch_name,
    SUM(a.balance) AS total_balance,
    RANK() OVER (PARTITION BY b.branch_name ORDER BY SUM(a.balance) DESC) AS branch_rank,
    SUM(SUM(a.balance)) OVER (PARTITION BY b.branch_name) AS branch_total,
    CAST(SUM(a.balance) * 100.0 / SUM(SUM(a.balance)) OVER (PARTITION BY b.branch_name) AS DECIMAL(5,2)) AS pct_of_branch
FROM Customers c
INNER JOIN Accounts a ON c.customer_id = a.customer_id
INNER JOIN Branches b ON a.branch_id = b.branch_id
WHERE a.status = 'Active'
GROUP BY c.first_name, c.last_name, b.branch_name
ORDER BY b.branch_name, branch_rank
GO

-- QUERY 19: Window Function - Running transaction balance
SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    a.account_number, t.transaction_date, t.transaction_type,
    t.description, t.amount, t.balance_after,
    SUM(CASE 
        WHEN t.transaction_type IN ('Deposit', 'Transfer In', 'Interest Credit', 'Refund') THEN t.amount 
        ELSE -t.amount 
    END) OVER (PARTITION BY a.account_id ORDER BY t.transaction_date, t.transaction_time) AS running_net_flow
FROM Transactions t
INNER JOIN Accounts a ON t.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id
WHERE c.last_name = 'Henderson' AND a.account_number = '10001001'
ORDER BY t.transaction_date, t.transaction_time
GO

-- QUERY 20: Window Function - Customer spending trend with LAG
WITH MonthlySpend AS (
    SELECT 
        c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
        CONVERT(CHAR(7), t.transaction_date, 126) AS spend_month,
        SUM(t.amount) AS monthly_total
    FROM Transactions t
    INNER JOIN Accounts a ON t.account_id = a.account_id
    INNER JOIN Customers c ON a.customer_id = c.customer_id
    WHERE t.transaction_type IN ('Card Payment', 'Contactless', 'Online Payment', 'Direct Debit')
    GROUP BY c.customer_id, c.first_name, c.last_name, CONVERT(CHAR(7), t.transaction_date, 126)
)
SELECT 
    customer_name, spend_month, monthly_total,
    LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY spend_month) AS prev_month_total,
    monthly_total - LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY spend_month) AS month_on_month_change,
    CASE 
        WHEN LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY spend_month) IS NULL THEN NULL
        WHEN LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY spend_month) = 0 THEN NULL
        ELSE CAST((monthly_total - LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY spend_month)) 
             * 100.0 / LAG(monthly_total) OVER (PARTITION BY customer_id ORDER BY spend_month) AS DECIMAL(5,2))
    END AS pct_change
FROM MonthlySpend
ORDER BY customer_name, spend_month
GO


CREATE VIEW vw_CustomerAccountSummary AS
SELECT 
    c.customer_id, c.first_name + ' ' + c.last_name AS customer_name,
    c.credit_score, c.annual_income, c.employment_status, c.city,
    b.branch_name AS home_branch,
    COUNT(a.account_id) AS total_accounts, SUM(a.balance) AS total_balance,
    SUM(a.overdraft_limit) AS total_overdraft,
    (SELECT COUNT(*) FROM Loans l WHERE l.customer_id = c.customer_id AND l.status = 'Active') AS active_loans,
    (SELECT SUM(l.outstanding_balance) FROM Loans l WHERE l.customer_id = c.customer_id AND l.status = 'Active') AS total_loan_balance,
    c.registration_date
FROM Customers c
INNER JOIN Accounts a ON c.customer_id = a.customer_id
LEFT JOIN Branches b ON c.home_branch_id = b.branch_id
WHERE a.status = 'Active' AND c.is_active = 1
GROUP BY c.customer_id, c.first_name, c.last_name, c.credit_score, c.annual_income, 
         c.employment_status, c.city, b.branch_name, c.registration_date
GO

CREATE VIEW vw_DailyTransactionFeed AS
SELECT 
    t.transaction_id, a.account_number,
    c.first_name + ' ' + c.last_name AS customer_name,
    t.transaction_type, t.amount, t.balance_after,
    t.transaction_date, t.transaction_time, t.description,
    t.channel, t.status, b.branch_name
FROM Transactions t
INNER JOIN Accounts a ON t.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id
INNER JOIN Branches b ON a.branch_id = b.branch_id
GO

CREATE VIEW vw_LoanPortfolioDashboard AS
SELECT 
    l.loan_id, c.first_name + ' ' + c.last_name AS customer_name,
    c.credit_score, l.loan_type, l.principal_amount, l.outstanding_balance,
    l.interest_rate, l.monthly_repayment, l.term_months, l.missed_payments,
    l.start_date, l.end_date, l.status,
    s.first_name + ' ' + s.last_name AS loan_officer, b.branch_name,
    CASE 
        WHEN l.missed_payments >= 3 THEN 'High Risk'
        WHEN l.missed_payments >= 1 THEN 'Medium Risk'
        WHEN c.credit_score < 600 THEN 'Watch List'
        ELSE 'Low Risk'
    END AS risk_category,
    CAST(l.outstanding_balance * 100.0 / NULLIF(l.principal_amount, 0) AS DECIMAL(5,2)) AS pct_remaining
FROM Loans l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN Staff s ON l.loan_officer_id = s.staff_id
INNER JOIN Accounts a ON l.account_id = a.account_id
INNER JOIN Branches b ON a.branch_id = b.branch_id
GO

CREATE VIEW vw_FraudAlertDashboard AS
SELECT 
    fa.alert_id, c.first_name + ' ' + c.last_name AS customer_name,
    a.account_number, fa.alert_type, fa.severity, fa.investigation_status,
    fa.description,
    s.first_name + ' ' + s.last_name AS assigned_analyst,
    fa.alert_date, fa.resolved_date,
    DATEDIFF(HOUR, fa.alert_date, ISNULL(fa.resolved_date, GETDATE())) AS hours_open,
    fa.resolution_notes
FROM Fraud_Alerts fa
INNER JOIN Accounts a ON fa.account_id = a.account_id
INNER JOIN Customers c ON a.customer_id = c.customer_id
LEFT JOIN Staff s ON fa.assigned_to = s.staff_id
GO

-- Test the views
SELECT * FROM vw_CustomerAccountSummary ORDER BY total_balance DESC
SELECT * FROM vw_DailyTransactionFeed WHERE transaction_date = '2024-10-01' ORDER BY transaction_time
SELECT * FROM vw_LoanPortfolioDashboard WHERE status = 'Active' ORDER BY risk_category
SELECT * FROM vw_FraudAlertDashboard WHERE investigation_status IN ('Open', 'Under Review', 'Escalated') ORDER BY severity
GO

