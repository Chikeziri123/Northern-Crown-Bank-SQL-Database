# Northern Crown Bank - Retail Banking Database Solution

## Introduction

Northern Crown Bank is a fictional UK high street bank operating across eight branches nationwide. In this project, I designed and implemented a comprehensive relational database solution that supports the bank's core retail operations using **Microsoft SQL Server (T-SQL)** and **SQL Server Management Studio (SSMS)**.

The database manages the full retail banking lifecycle: customer onboarding and KYC verification, multi-product account management, real-time transaction processing, loan origination and repayment tracking, debit and credit card administration, standing order management, automated fraud detection, and regulatory audit compliance.

This project was built to demonstrate how a well-designed relational database can solve real operational challenges in financial services, from preventing double-spending through transactional integrity to flagging suspicious activity through automated triggers.

## Business Context

### The Problem

A growing UK retail bank with eight branches needs a centralised data solution to manage its expanding customer base and product portfolio. The bank currently struggles with fragmented data across branches, manual fraud detection processes, inconsistent loan risk monitoring, and limited visibility into customer behaviour across channels. Without a unified database, the bank cannot efficiently track transactions, monitor loan performance, detect fraud in real time, or generate the management reports needed for strategic decision-making.

### The Solution

A normalised relational database built in Microsoft SQL Server that serves as the single source of truth for all retail banking operations. The solution provides automated fraud flagging through database triggers, transactional fund transfers with rollback protection to prevent data inconsistency, loan risk categorisation using CTEs for portfolio monitoring, customer spending trend analysis using window functions, and reporting views that power dashboards for relationship managers, loan officers, fraud analysts, and senior management.

## Branch Network and Products

### UK Branch Locations

| Branch | City | Manager |
|--------|------|---------|
| Newcastle City Centre | Newcastle upon Tyne | Richard Hewitt |
| Leeds Wellington Street | Leeds | Sarah Thornton |
| Manchester Deansgate | Manchester | James Okoro |
| Edinburgh Princes Street | Edinburgh | Fiona Campbell |
| Birmingham New Street | Birmingham | David Patel |
| Bristol Harbour | Bristol | Claire Robinson |
| London Canary Wharf | London | Adebayo Williams |
| Glasgow Buchanan Street | Glasgow | Hamish MacLeod |

### Retail Banking Products

| Product | Category | Interest Rate | Monthly Fee | Overdraft |
|---------|----------|--------------|-------------|-----------|
| Crown Current Account | Current | 0.00% | Free | Yes |
| Crown Plus Account | Current (Premium) | 0.10% | 12.50 | Yes |
| Crown Saver | Savings | 3.25% | Free | No |
| Crown Fixed Rate Saver | Fixed Deposit (12m) | 4.50% | Free | No |
| Crown Cash ISA | ISA | 3.75% | Free | No |
| Crown Student Account | Student | 0.00% | Free | Yes (up to 2,000) |
| Crown Junior Saver | Junior | 3.50% | Free | No |

## Database Design

### Design Approach

The database was designed following a structured methodology. I began with requirements gathering to understand the bank's operational needs across customer management, transaction processing, lending, card services, and compliance. I then created a conceptual entity-relationship diagram (ERD) using Quick Database Diagrams to map out entities and their relationships. This was translated into a logical model with normalisation up to Third Normal Form (3NF) to eliminate data redundancy. Finally, the physical implementation was built in SQL Server with appropriate data types, constraints, indexes, and default values optimised for the expected query patterns.

### Schema Overview (12 Tables)

| Table | Records | Purpose |
|-------|---------|---------|
| `Branches` | 8 | UK branch locations with address, manager, phone, and opening date |
| `Staff` | 18 | Employees across 8 roles including Branch Managers, Relationship Managers, Tellers, Loan Officers, Fraud Analysts, Customer Service, Compliance Officers, and Admin |
| `Customers` | 20 | Customer demographics, National Insurance number, KYC verification status, credit score (0-999), employment status, annual income, and home branch assignment |
| `Account_Types` | 7 | Banking product catalogue with interest rates, monthly fees, overdraft eligibility, and minimum opening balance requirements |
| `Accounts` | 30 | Customer accounts with 8-digit account numbers, sort codes, balances, overdraft limits, and status tracking (Active, Dormant, Frozen, Closed) |
| `Transactions` | 100+ | Financial movements including Deposits, Withdrawals, Card Payments, Contactless, Transfers, Direct Debits, Standing Orders, Online Payments, Interest Credits, Fee Charges, and Refunds |
| `Cards` | 23 | Debit, Credit, and Prepaid cards with masked card numbers, daily spending limits, contactless settings, expiry dates, and status management (Active, Blocked, Lost, Stolen) |
| `Loans` | 11 | Personal Loans, Mortgages, Car Finance, Overdrafts, and Credit Builder products with principal, interest rate, term, monthly repayment, outstanding balance, and missed payment tracking |
| `Loan_Repayments` | 12 | Individual repayment records with principal/interest split, due dates, payment dates, late status, and days overdue |
| `Standing_Orders` | 12 | Recurring payments for rent, mortgages, council tax, utilities, and insurance with frequency, payee details, and next payment scheduling |
| `Fraud_Alerts` | 8 | Suspected fraudulent activity covering Unusual Transactions, Location Mismatches, Rapid Spending, Large Withdrawals, Card Not Present fraud, Multiple Failed Logins, Account Takeover, and Identity Theft, with severity levels and investigation workflow |
| `Audit_Log` | Dynamic | Automated compliance trail recording all INSERT, UPDATE, and DELETE operations across the system with timestamps and user tracking |

### Key Relationships

The database enforces referential integrity through foreign key constraints across all tables:

- **Customers to Branches**: Each customer is assigned a home branch for relationship management
- **Accounts to Customers, Account Types, Branches**: Supports multi-product relationships where a single customer can hold current, savings, ISA, and fixed deposit accounts simultaneously
- **Transactions to Accounts**: Every financial movement is linked to a source account, with transfer transactions also referencing the destination account through the `related_account_id` field
- **Cards to Accounts and Customers**: Debit and credit cards are tied to specific accounts, enabling card-level spending controls and fraud monitoring
- **Loans to Customers, Accounts, Staff**: The full lending chain connects the borrower, their repayment account, and the loan officer who approved the facility
- **Loan Repayments to Loans and Accounts**: Individual payment tracking with principal/interest breakdown enables amortisation analysis and arrears monitoring
- **Standing Orders to Accounts**: Recurring payment scheduling with frequency, payee details, and automatic next-payment-date calculation
- **Fraud Alerts to Accounts, Transactions, Cards, Staff**: Investigation workflow connecting the flagged account, the suspicious transaction or card, and the assigned fraud analyst
- **Audit Log**: Automatically populated by triggers to maintain a tamper-evident record of all system changes for FCA regulatory compliance

### Data Integrity Features

- **CHECK constraints** enforce business rules at the database level: credit scores must be between 0 and 999, customers must be at least 16 years old, loan amounts must be positive, card numbers must be exactly 4 digits, overdraft limits cannot be negative, and loan end dates must follow start dates
- **FOREIGN KEY constraints** ensure no orphaned records can exist across the 12-table schema
- **DEFAULT values** automate common fields: account status defaults to Active, transaction status to Completed, sort codes to the bank's standard prefix, and timestamps to the current date/time
- **Non-clustered indexes** on 20+ columns optimise the most common query patterns including transaction date lookups, account status filtering, credit score ranges, fraud severity sorting, and customer name searches

## Technical Implementation

### Part 1: Schema Design (DDL)

The schema creation script establishes all 12 tables with their columns, data types, constraints, relationships, and indexes. Tables are created in dependency order to satisfy foreign key references. The script uses `IDENTITY(1,1)` for auto-incrementing primary keys and includes named constraints for easier maintenance and debugging.

### Part 2: Sample Data (DML)

The sample data was designed to reflect realistic UK retail banking patterns:

- **20 customers** distributed across 8 UK cities with authentic postcodes, diverse demographics, income bands ranging from 8,000 (students) to 95,000 (investment bankers), and credit scores from 450 to 850
- **30 accounts** spanning all 7 product types, demonstrating multi-product customer relationships where higher-income customers hold premium accounts alongside savings and ISA products
- **100+ transactions** across October to December 2024, including monthly salary deposits, mortgage and rent direct debits, everyday card payments at recognisable UK retailers (Tesco, Sainsburys, Greggs, Nandos), subscription payments (Netflix, Spotify, Sky), seasonal Christmas shopping, inter-account transfers, and ATM withdrawals across multiple channels (Online, Mobile, Branch, ATM, Contactless, Auto)
- **11 active loans** including personal loans (5.40-8.90% APR), mortgages (3.50-4.25% over 25 years), car finance (6.80-7.20%), and credit builder products (19.90%) reflecting realistic UK lending rates
- **12 loan repayments** demonstrating on-time payments, missed payments, and late payments with days-overdue tracking
- **12 standing orders** for recurring bills including rent, mortgages, council tax, utilities, insurance, and family savings contributions
- **8 fraud alerts** covering diverse scenarios: location mismatch (card used in London while customer is in Manchester), rapid spending patterns, large cash advances unusual for customer profile, card-not-present fraud attempts, mobile banking account takeover, and Christmas shopping flagged by spending threshold

### Part 3A: Queries and Views

#### Basic to Intermediate Queries (Queries 1 to 10)

These queries demonstrate core SQL skills using multi-table JOINs, WHERE filtering, ORDER BY, and subqueries:

| Query | Business Question | Tables Joined |
|-------|-------------------|---------------|
| 1 | Who are our active customers and what are their credit profiles? | Customers |
| 2 | How is our workforce distributed across branches and roles? | Staff, Branches |
| 3 | What accounts do we hold, broken down by product and branch? | Accounts, Customers, Account_Types, Branches |
| 4 | What was a specific customer's transaction history last month? | Transactions, Accounts, Customers |
| 5 | What active cards are in circulation with their spending limits? | Cards, Accounts, Customers, Account_Types |
| 6 | What is our active loan book and who are the responsible officers? | Loans, Customers, Staff |
| 7 | What standing orders are due for processing next? | Standing_Orders, Accounts, Customers |
| 8 | What fraud cases are open and how severe are they? | Fraud_Alerts, Accounts, Customers, Staff |
| 9 | Which loan repayments were missed or late this quarter? | Loan_Repayments, Loans, Customers |
| 10 | Which customers are on our credit risk watch list and what is their total exposure? | Customers, Branches, Loans (subquery) |

#### Aggregate and Analytical Queries (Queries 11 to 15)

These queries use GROUP BY, aggregate functions (COUNT, SUM, AVG, MIN, MAX), CASE expressions, and percentage calculations:

| Query | Business Question |
|-------|-------------------|
| 11 | What are our monthly transaction volumes, values, and active account counts? |
| 12 | How do our transaction types compare by volume and value? |
| 13 | How do our branches perform against each other in terms of accounts, customers, and total balances? |
| 14 | Which transaction channels (Online, Mobile, ATM, Contactless) are customers using most? |
| 15 | How is our customer base distributed across income bands, and what are the average credit scores per band? |

#### CTEs and Window Functions (Queries 16 to 20)

These queries demonstrate advanced T-SQL techniques:

| Query | Technique | Business Question |
|-------|-----------|-------------------|
| 16 | CTE | What is each customer's total portfolio value across all accounts, and what is their savings-to-income ratio? |
| 17 | CTE with CASE | How does our loan book break down by risk category (High Risk, Medium Risk, Watch List, Low Risk) and what is our total exposure per category? |
| 18 | RANK() with PARTITION BY | Who are the highest-value customers at each branch, and what share of branch deposits do they represent? |
| 19 | SUM() OVER() | What is the running net cash flow on a customer's account across all transactions chronologically? |
| 20 | LAG() with PARTITION BY | How is each customer's monthly spending trending, and what is the month-on-month percentage change? |

#### Reporting Views (4 Views)

These views encapsulate complex joins into reusable objects that can power dashboards and operational reporting:

| View | Target User | Key Metrics |
|------|-------------|-------------|
| `vw_CustomerAccountSummary` | Relationship Managers | Total balance, number of accounts, active loans, loan balance, active cards, registration date |
| `vw_DailyTransactionFeed` | Operations Team | Real-time transaction list with customer name, account number, channel, branch, and status |
| `vw_LoanPortfolioDashboard` | Loan Officers and Risk Team | Loan details with risk categorisation (High/Medium/Watch/Low), percentage of principal remaining, missed payments |
| `vw_FraudAlertDashboard` | Fraud Analysts | Alert details with severity, hours open since alert, assigned analyst, investigation status, resolution notes |

### Part 3B: Stored Procedures, Triggers, and DML

#### Stored Procedures (5 Procedures)

Each procedure includes input validation, error handling with RAISERROR, and automatic audit logging:

| Procedure | Purpose | Key Features |
|-----------|---------|--------------|
| `sp_OpenAccount` | Open a new account for an existing customer | Validates customer is active, checks account type exists, enforces minimum opening balance, auto-generates unique 8-digit account number, logs initial deposit as a transaction |
| `sp_TransferFunds` | Transfer money between two accounts | Validates both accounts are active, checks sufficient funds including overdraft limit, uses BEGIN TRANSACTION with COMMIT for atomic execution, creates paired Transfer Out/Transfer In transaction records |
| `sp_BlockCard` | Block a card reported as lost, stolen, or compromised | Validates card is currently active, updates card status, optionally raises an automatic fraud alert with appropriate severity and alert type |
| `sp_MonthlyStatement` | Generate a formatted monthly account statement | Displays customer and account details, lists all transactions with credit/debit split, calculates period summary totals |
| `sp_BankPerformanceReport` | Generate a bank-wide monthly performance report | Covers transaction volumes by channel, active loan book with missed payments, and fraud alert summary with open case count |

#### Triggers (3 Audit Triggers)

| Trigger | Fires On | Purpose |
|---------|----------|---------|
| `trg_AuditCustomerUpdate` | Customers (AFTER UPDATE) | Logs every customer record change to the Audit_Log and auto-updates the `updated_date` timestamp |
| `trg_FlagLargeTransaction` | Transactions (AFTER INSERT) | Automatically creates a fraud alert for any withdrawal, transfer, or payment exceeding 5,000, enabling real-time fraud monitoring without manual intervention |
| `trg_AuditAccountStatusChange` | Accounts (AFTER UPDATE) | Tracks account status transitions (e.g., Active to Frozen, Active to Closed) for compliance and operational monitoring |

#### DML Operations

- **UPDATE**: Customer phone numbers, credit score adjustments after annual review, loan repayment status corrections, fraud alert resolution with notes
- **DELETE**: Safe deletion of completed standing orders using EXISTS check to prevent accidental removal of active orders

## File Structure

```
Northern_Crown_Bank/
|
|-- Northern_Crown_Bank_Part1_Schema.sql              -- DDL: 12 tables, constraints, indexes
|-- Northern_Crown_Bank_Part2_SampleData.sql           -- DML: Full sample data across all tables
|-- Northern_Crown_Bank_Part3A_Queries.sql             -- 20 queries (basic to window functions) + 4 views
|-- Northern_Crown_Bank_Part3B_SPsTriggersTests.sql    -- 5 stored procedures, 3 triggers, DML, tests
|-- README.md                                          -- Project documentation
```

## How to Run

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance
3. Execute **Part 1** to create the `Northern_Crown_Bank` database and all 12 tables with constraints and indexes
4. Execute **Part 2** to populate all tables with sample data (run in order as foreign keys enforce dependencies)
5. Execute **Part 3A** to run all 20 analytical queries and create 4 reporting views
6. Execute **Part 3B** to create stored procedures, triggers, run DML operations, and test all procedures

**Note**: Run the files in strict order as each part depends on objects created in previous parts. Each `CREATE PROCEDURE`, `CREATE VIEW`, and `CREATE TRIGGER` statement is preceded by a `GO` batch separator for SQL Server Express compatibility.

## Tools and Technologies

- **Microsoft SQL Server Express** (LocalDB, version 16.0)
- **SQL Server Management Studio (SSMS)** for development, testing, and execution
- **T-SQL** for all database programming and query development
- **Quick Database Diagrams** for entity-relationship diagram design

## Skills Demonstrated

- Relational database design and normalisation up to Third Normal Form (3NF)
- T-SQL programming including stored procedures with input validation and error handling
- Transactional integrity using BEGIN TRANSACTION and COMMIT for atomic fund transfers
- Database triggers for automated fraud detection and audit compliance
- Complex multi-table JOIN queries across up to 5 tables
- Aggregate functions with GROUP BY for financial and operational reporting
- Common Table Expressions (CTEs) for loan risk categorisation and portfolio analysis
- Window functions including RANK(), LAG(), and cumulative SUM() OVER() for trend analysis
- Data validation using CHECK constraints, FOREIGN KEY constraints, and stored procedure logic
- Indexing strategy across 20+ columns for query performance optimisation
- Audit trail implementation aligned with FCA regulatory compliance requirements
- DML operations (INSERT, UPDATE, DELETE) with error handling and safety checks
- Financial services domain knowledge including KYC, credit scoring, loan risk categorisation, amortisation tracking, standing order management, and multi-channel transaction processing

## Author

**Chikeziri Nnodum** | Data Analyst

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/chikeziri-nnodum/) 

## Licence

This project is for portfolio and educational purposes. All customer data, financial data, and institutional references are entirely fictional. No real banking data, National Insurance numbers, or personal information was used. Northern Crown Bank is a fictional institution created solely for this project.
