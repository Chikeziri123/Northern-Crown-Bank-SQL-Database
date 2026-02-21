USE Northern_Crown_Bank
GO

-- ============================================================================
-- INSERT: Branches
-- ============================================================================
INSERT INTO Branches (branch_name, address_line1, address_line2, city, postcode, phone_number, manager_name, opening_date)
VALUES
    ('Newcastle City Centre', '45 Grey Street', NULL, 'Newcastle upon Tyne', 'NE1 6EE', '0191 200 1001', 'Richard Hewitt', '2005-03-15'),
    ('Leeds Wellington Street', '12 Wellington Street', NULL, 'Leeds', 'LS1 4LT', '0113 200 1002', 'Sarah Thornton', '2008-06-20'),
    ('Manchester Deansgate', '88 Deansgate', 'Floor 1', 'Manchester', 'M3 2ER', '0161 200 1003', 'James Okoro', '2006-09-10'),
    ('Edinburgh Princes Street', '134 Princes Street', NULL, 'Edinburgh', 'EH2 4AD', '0131 200 1004', 'Fiona Campbell', '2010-01-05'),
    ('Birmingham New Street', '22 New Street', NULL, 'Birmingham', 'B2 4QA', '0121 200 1005', 'David Patel', '2007-11-18'),
    ('Bristol Harbour', '7 Harbourside', 'Unit 3', 'Bristol', 'BS1 5BD', '0117 200 1006', 'Claire Robinson', '2012-04-22'),
    ('London Canary Wharf', '1 Canada Square', 'Level 2', 'London', 'E14 5AB', '0207 200 1007', 'Adebayo Williams', '2004-08-01'),
    ('Glasgow Buchanan Street', '56 Buchanan Street', NULL, 'Glasgow', 'G1 3HA', '0141 200 1008', 'Hamish MacLeod', '2011-02-14')
GO

-- ============================================================================
-- INSERT: Staff
-- ============================================================================
INSERT INTO Staff (first_name, last_name, job_role, branch_id, email, phone_number, hire_date)
VALUES
    ('Richard', 'Hewitt', 'Branch Manager', 1, 'richard.hewitt@northerncrown.co.uk', '07700200001', '2005-03-15'),
    ('Sarah', 'Thornton', 'Branch Manager', 2, 'sarah.thornton@northerncrown.co.uk', '07700200002', '2008-06-20'),
    ('James', 'Okoro', 'Branch Manager', 3, 'james.okoro@northerncrown.co.uk', '07700200003', '2006-09-10'),
    ('Priya', 'Nair', 'Relationship Manager', 1, 'priya.nair@northerncrown.co.uk', '07700200004', '2019-03-11'),
    ('Michael', 'Dawson', 'Relationship Manager', 2, 'michael.dawson@northerncrown.co.uk', '07700200005', '2020-07-15'),
    ('Amina', 'Hassan', 'Loan Officer', 1, 'amina.hassan@northerncrown.co.uk', '07700200006', '2018-11-20'),
    ('Thomas', 'Fletcher', 'Loan Officer', 3, 'thomas.fletcher@northerncrown.co.uk', '07700200007', '2021-01-10'),
    ('Grace', 'Obi', 'Teller', 1, 'grace.obi@northerncrown.co.uk', '07700200008', '2022-05-16'),
    ('Daniel', 'Cooper', 'Teller', 2, 'daniel.cooper@northerncrown.co.uk', '07700200009', '2021-09-01'),
    ('Laura', 'Singh', 'Teller', 3, 'laura.singh@northerncrown.co.uk', '07700200010', '2023-02-06'),
    ('Robert', 'Matthews', 'Fraud Analyst', 7, 'robert.matthews@northerncrown.co.uk', '07700200011', '2019-08-12'),
    ('Zara', 'Ahmed', 'Fraud Analyst', 7, 'zara.ahmed@northerncrown.co.uk', '07700200012', '2021-04-18'),
    ('Helen', 'Murray', 'Compliance Officer', 7, 'helen.murray@northerncrown.co.uk', '07700200013', '2017-06-01'),
    ('Benjamin', 'Clarke', 'Customer Service', 1, 'benjamin.clarke@northerncrown.co.uk', '07700200014', '2022-10-03'),
    ('Fatima', 'Yusuf', 'Customer Service', 4, 'fatima.yusuf@northerncrown.co.uk', '07700200015', '2023-01-09'),
    ('Andrew', 'Scott', 'Loan Officer', 5, 'andrew.scott@northerncrown.co.uk', '07700200016', '2020-05-11'),
    ('Emma', 'Richardson', 'Relationship Manager', 6, 'emma.richardson@northerncrown.co.uk', '07700200017', '2019-12-02'),
    ('Kwame', 'Mensah', 'Admin', 7, 'kwame.mensah@northerncrown.co.uk', '07700200018', '2022-03-28')
GO

-- ============================================================================
-- INSERT: Customers
-- ============================================================================
INSERT INTO Customers (first_name, last_name, date_of_birth, gender, national_insurance, address_line1, address_line2, city, postcode, phone_number, email, employment_status, annual_income, credit_score, kyc_verified, home_branch_id, registration_date)
VALUES
    ('John', 'Henderson', '1985-04-12', 'Male', 'AB123456C', '14 Grey Street', NULL, 'Newcastle upon Tyne', 'NE1 6AE', '07712345001', 'john.henderson@email.com', 'Employed', 42000.00, 720, 1, 1, '2020-01-15'),
    ('Amara', 'Osei', '1992-08-25', 'Female', 'CD234567D', '27 Jesmond Road', 'Flat 3', 'Newcastle upon Tyne', 'NE2 1LA', '07712345002', 'amara.osei@email.com', 'Employed', 38000.00, 680, 1, 1, '2020-06-10'),
    ('Peter', 'Clark', '1958-11-03', 'Male', 'EF345678E', '8 Headingley Lane', NULL, 'Leeds', 'LS6 1BN', '07712345003', 'peter.clark@email.com', 'Retired', 22000.00, 810, 1, 2, '2019-03-20'),
    ('Fatima', 'Khan', '1990-02-17', 'Female', 'GH456789F', '52 Deansgate', 'Apt 12', 'Manchester', 'M3 2EG', '07712345004', 'fatima.khan@email.com', 'Self-Employed', 55000.00, 650, 1, 3, '2021-01-08'),
    ('Steven', 'Brown', '1975-07-30', 'Male', 'IJ567890G', '19 Morningside Road', NULL, 'Edinburgh', 'EH10 4AX', '07712345005', 'steven.brown@email.com', 'Employed', 67000.00, 760, 1, 4, '2019-11-15'),
    ('Emma', 'Taylor', '2001-12-09', 'Female', 'KL678901H', '33 Broad Street', 'Flat 7B', 'Birmingham', 'B1 2HF', '07712345006', 'emma.taylor@email.com', 'Employed', 28000.00, 590, 1, 5, '2022-03-20'),
    ('Mohammed', 'Rahman', '1968-05-14', 'Male', 'MN789012I', '5 Park Street', NULL, 'Bristol', 'BS1 5NH', '07712345007', 'mohammed.rahman@email.com', 'Employed', 48000.00, 740, 1, 6, '2020-05-12'),
    ('Claire', 'Stephenson', '1983-09-21', 'Female', 'OP890123J', '41 Canary Wharf', NULL, 'London', 'E14 5AH', '07712345008', 'claire.stephenson@email.com', 'Employed', 85000.00, 830, 1, 7, '2019-07-03'),
    ('Daniel', 'Mbeki', '1995-01-28', 'Male', 'QR901234K', '16 Sauchiehall Street', 'Flat 2A', 'Glasgow', 'G2 3AH', '07712345009', 'daniel.mbeki@email.com', 'Employed', 35000.00, 610, 1, 8, '2022-09-10'),
    ('Sophie', 'Reed', '2003-06-15', 'Female', 'ST012345L', '22 Fenham Hall Drive', NULL, 'Newcastle upon Tyne', 'NE4 9XB', '07712345010', 'sophie.reed@email.com', 'Student', 9500.00, 450, 1, 1, '2023-08-22'),
    ('George', 'Wilkinson', '1950-03-08', 'Male', 'UV123456M', '7 Dene Crescent', NULL, 'Leeds', 'LS8 1AY', '07712345011', 'george.w@email.com', 'Retired', 18500.00, 790, 1, 2, '2018-04-05'),
    ('Lily', 'Chen', '1999-10-22', 'Female', 'WX234567N', '38 Northern Quarter', 'Flat 5', 'Manchester', 'M4 1EQ', '07712345012', 'lily.chen@email.com', 'Employed', 32000.00, 660, 1, 3, '2023-02-14'),
    ('Nathan', 'Foster', '1972-08-05', 'Male', 'YZ345678O', '11 Leith Walk', NULL, 'Edinburgh', 'EH6 5AH', '07712345013', 'nathan.foster@email.com', 'Self-Employed', 72000.00, 700, 1, 4, '2020-09-18'),
    ('Aisha', 'Patel', '1988-04-30', 'Female', 'AB456789P', '29 Jewellery Quarter', NULL, 'Birmingham', 'B3 1JL', '07712345014', 'aisha.patel@email.com', 'Employed', 44000.00, 730, 1, 5, '2021-11-01'),
    ('Oliver', 'Grant', '2002-02-18', 'Male', 'CD567890Q', '6 Whiteladies Road', NULL, 'Bristol', 'BS8 1NU', '07712345015', 'oliver.grant@email.com', 'Student', 8000.00, 480, 1, 6, '2023-04-05'),
    ('Hannah', 'Murray', '1980-11-27', 'Female', 'EF678901R', '45 Shoreditch High St', 'Floor 2', 'London', 'E1 6JE', '07712345016', 'hannah.m@email.com', 'Employed', 95000.00, 850, 1, 7, '2019-01-30'),
    ('Callum', 'Turnbull', '1963-06-19', 'Male', 'GH789012S', '13 Byres Road', NULL, 'Glasgow', 'G11 5RD', '07712345017', 'callum.t@email.com', 'Employed', 52000.00, 710, 1, 8, '2020-08-12'),
    ('Zainab', 'Ibrahim', '1997-03-11', 'Female', 'IJ890123T', '20 Quayside', 'Flat 9', 'Newcastle upon Tyne', 'NE1 3DE', '07712345018', 'zainab.i@email.com', 'Employed', 31000.00, 640, 1, 1, '2023-05-20'),
    ('Brian', 'Dodds', '1945-09-02', 'Male', 'KL901234U', '3 The Headrow', NULL, 'Leeds', 'LS1 6PU', '07712345019', 'brian.dodds@email.com', 'Retired', 16000.00, 820, 1, 2, '2017-03-25'),
    ('Jessica', 'Okonkwo', '1993-07-08', 'Female', 'MN012345V', '31 Deansgate Locks', 'Apt 14', 'Manchester', 'M1 5LH', '07712345020', 'jessica.o@email.com', 'Employed', 41000.00, 690, 1, 3, '2021-12-08')
GO

-- ============================================================================
-- INSERT: Account_Types
-- ============================================================================
INSERT INTO Account_Types (type_name, category, interest_rate, monthly_fee, overdraft_available, min_opening_balance, description)
VALUES
    ('Crown Current Account', 'Current', 0.00, 0.00, 1, 0.00, 'Everyday banking with free UK payments and a contactless debit card'),
    ('Crown Plus Account', 'Current', 0.10, 12.50, 1, 0.00, 'Premium current account with travel insurance, breakdown cover, and cashback'),
    ('Crown Saver', 'Savings', 3.25, 0.00, 0, 1.00, 'Easy-access savings with competitive interest and no penalties for withdrawals'),
    ('Crown Fixed Rate Saver', 'Fixed Deposit', 4.50, 0.00, 0, 1000.00, '12-month fixed rate with guaranteed returns. No withdrawals until maturity'),
    ('Crown Cash ISA', 'ISA', 3.75, 0.00, 0, 1.00, 'Tax-free savings up to the annual ISA allowance'),
    ('Crown Student Account', 'Student', 0.00, 0.00, 1, 0.00, 'Student current account with interest-free overdraft up to 2000'),
    ('Crown Junior Saver', 'Junior', 3.50, 0.00, 0, 1.00, 'Savings account for under-18s managed by a parent or guardian')
GO

-- ============================================================================
-- INSERT: Accounts
-- ============================================================================
INSERT INTO Accounts (account_number, sort_code, customer_id, account_type_id, branch_id, balance, overdraft_limit, opening_date, status, last_transaction_date)
VALUES
    ('10001001', '20-45-67', 1, 1, 1, 3420.50, 1000.00, '2020-01-15', 'Active', '2024-12-15'),
    ('10001002', '20-45-67', 1, 3, 1, 12500.00, 0.00, '2020-03-10', 'Active', '2024-12-01'),
    ('10001003', '20-45-67', 2, 1, 1, 1875.30, 500.00, '2020-06-10', 'Active', '2024-12-14'),
    ('10001004', '20-45-67', 3, 1, 2, 8920.75, 1500.00, '2019-03-20', 'Active', '2024-12-12'),
    ('10001005', '20-45-67', 3, 5, 2, 45000.00, 0.00, '2019-05-01', 'Active', '2024-11-15'),
    ('10001006', '20-45-67', 4, 1, 3, 2340.60, 750.00, '2021-01-08', 'Active', '2024-12-15'),
    ('10001007', '20-45-67', 4, 3, 3, 8200.00, 0.00, '2021-03-15', 'Active', '2024-12-10'),
    ('10001008', '20-45-67', 5, 2, 4, 15670.80, 2000.00, '2019-11-15', 'Active', '2024-12-15'),
    ('10001009', '20-45-67', 5, 4, 4, 25000.00, 0.00, '2024-01-10', 'Active', '2024-01-10'),
    ('10001010', '20-45-67', 6, 1, 5, 890.25, 500.00, '2022-03-20', 'Active', '2024-12-14'),
    ('10001011', '20-45-67', 7, 1, 6, 5430.90, 1000.00, '2020-05-12', 'Active', '2024-12-13'),
    ('10001012', '20-45-67', 7, 3, 6, 22000.00, 0.00, '2020-07-01', 'Active', '2024-12-01'),
    ('10001013', '20-45-67', 8, 2, 7, 28450.00, 3000.00, '2019-07-03', 'Active', '2024-12-15'),
    ('10001014', '20-45-67', 8, 4, 7, 50000.00, 0.00, '2024-06-01', 'Active', '2024-06-01'),
    ('10001015', '20-45-67', 9, 1, 8, 1250.40, 500.00, '2022-09-10', 'Active', '2024-12-11'),
    ('10001016', '20-45-67', 10, 6, 1, 420.00, 1500.00, '2023-08-22', 'Active', '2024-12-10'),
    ('10001017', '20-45-67', 11, 1, 2, 14200.00, 1000.00, '2018-04-05', 'Active', '2024-12-08'),
    ('10001018', '20-45-67', 12, 1, 3, 2100.75, 500.00, '2023-02-14', 'Active', '2024-12-13'),
    ('10001019', '20-45-67', 13, 1, 4, 6780.30, 1500.00, '2020-09-18', 'Active', '2024-12-15'),
    ('10001020', '20-45-67', 13, 3, 4, 35000.00, 0.00, '2021-01-05', 'Active', '2024-12-01'),
    ('10001021', '20-45-67', 14, 1, 5, 3560.40, 750.00, '2021-11-01', 'Active', '2024-12-14'),
    ('10001022', '20-45-67', 15, 6, 6, 340.00, 1500.00, '2023-04-05', 'Active', '2024-12-09'),
    ('10001023', '20-45-67', 16, 2, 7, 42300.00, 5000.00, '2019-01-30', 'Active', '2024-12-15'),
    ('10001024', '20-45-67', 16, 5, 7, 20000.00, 0.00, '2020-04-01', 'Active', '2024-11-20'),
    ('10001025', '20-45-67', 17, 1, 8, 4870.55, 1000.00, '2020-08-12', 'Active', '2024-12-12'),
    ('10001026', '20-45-67', 18, 1, 1, 1680.90, 500.00, '2023-05-20', 'Active', '2024-12-14'),
    ('10001027', '20-45-67', 19, 1, 2, 9850.00, 500.00, '2017-03-25', 'Active', '2024-12-10'),
    ('10001028', '20-45-67', 19, 3, 2, 31000.00, 0.00, '2018-01-10', 'Active', '2024-12-01'),
    ('10001029', '20-45-67', 20, 1, 3, 2980.15, 750.00, '2021-12-08', 'Active', '2024-12-13'),
    ('10001030', '20-45-67', 20, 3, 3, 7500.00, 0.00, '2022-02-01', 'Active', '2024-11-30')
GO

-- ============================================================================
-- INSERT: Transactions (October - December 2024)
-- ============================================================================
INSERT INTO Transactions (account_id, transaction_type, amount, balance_after, transaction_date, transaction_time, description, reference_number, channel, related_account_id, status)
VALUES
    -- Customer 1 - John Henderson (Current: account_id depends on IDENTITY)
    -- We will use sequential IDs based on insertion order. Account 1 = first inserted, etc.
    -- Account 1 = John Current, Account 2 = John Savings
    (1, 'Deposit', 2800.00, 4220.50, '2024-10-01', '08:30', 'Salary - Henderson Engineering Ltd', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (1, 'Direct Debit', 850.00, 3370.50, '2024-10-03', '06:00', 'Mortgage payment - Halifax', 'DD-MORT-OCT', 'Auto', NULL, 'Completed'),
    (1, 'Card Payment', 45.60, 3324.90, '2024-10-05', '12:15', 'Tesco Metro - Grey Street', NULL, 'Contactless', NULL, 'Completed'),
    (1, 'Card Payment', 120.00, 3204.90, '2024-10-08', '19:30', 'Dabbawal Restaurant Newcastle', NULL, 'Contactless', NULL, 'Completed'),
    (1, 'Transfer Out', 500.00, 2704.90, '2024-10-10', '10:00', 'Transfer to Crown Saver', 'TRF-001', 'Mobile', 2, 'Completed'),
    (2, 'Transfer In', 500.00, 13000.00, '2024-10-10', '10:00', 'Transfer from Current Account', 'TRF-001', 'Mobile', 1, 'Completed'),
    (1, 'Standing Order', 200.00, 2504.90, '2024-10-15', '07:00', 'Council Tax - Newcastle City', 'SO-CT-OCT', 'Auto', NULL, 'Completed'),
    (1, 'Contactless', 3.80, 2501.10, '2024-10-16', '07:45', 'Pret A Manger - Central Station', NULL, 'Contactless', NULL, 'Completed'),
    (1, 'Online Payment', 15.99, 2485.11, '2024-10-18', '20:10', 'Netflix Subscription', 'NFLX-OCT', 'Online', NULL, 'Completed'),
    (1, 'Withdrawal', 200.00, 2285.11, '2024-10-22', '14:00', 'ATM Withdrawal - Northumberland St', 'ATM-1022', 'ATM', NULL, 'Completed'),
    (1, 'Deposit', 2800.00, 5085.11, '2024-11-01', '08:30', 'Salary - Henderson Engineering Ltd', 'SAL-NOV24', 'Auto', NULL, 'Completed'),
    (1, 'Direct Debit', 850.00, 4235.11, '2024-11-03', '06:00', 'Mortgage payment - Halifax', 'DD-MORT-NOV', 'Auto', NULL, 'Completed'),
    (1, 'Card Payment', 67.30, 4167.81, '2024-11-07', '13:20', 'Marks & Spencer Newcastle', NULL, 'Contactless', NULL, 'Completed'),
    (1, 'Direct Debit', 120.00, 4047.81, '2024-11-10', '06:00', 'Sky TV Subscription', 'DD-SKY-NOV', 'Auto', NULL, 'Completed'),
    (1, 'Transfer Out', 750.00, 3297.81, '2024-11-12', '09:30', 'Transfer to Crown Saver', 'TRF-002', 'Online', 2, 'Completed'),
    (2, 'Transfer In', 750.00, 13750.00, '2024-11-12', '09:30', 'Transfer from Current Account', 'TRF-002', 'Online', 1, 'Completed'),
    (1, 'Deposit', 2800.00, 6097.81, '2024-12-01', '08:30', 'Salary - Henderson Engineering Ltd', 'SAL-DEC24', 'Auto', NULL, 'Completed'),
    (1, 'Direct Debit', 850.00, 5247.81, '2024-12-03', '06:00', 'Mortgage payment - Halifax', 'DD-MORT-DEC', 'Auto', NULL, 'Completed'),
    (1, 'Card Payment', 234.50, 5013.31, '2024-12-07', '15:45', 'John Lewis - Eldon Square', NULL, 'Online', NULL, 'Completed'),
    (1, 'Card Payment', 89.99, 4923.32, '2024-12-10', '10:30', 'Amazon UK - Christmas gifts', 'AMZ-DEC10', 'Online', NULL, 'Completed'),
    (1, 'Transfer Out', 1000.00, 3923.32, '2024-12-12', '11:00', 'Transfer to Crown Saver', 'TRF-003', 'Mobile', 2, 'Completed'),
    (2, 'Transfer In', 1000.00, 14750.00, '2024-12-12', '11:00', 'Transfer from Current Account', 'TRF-003', 'Mobile', 1, 'Completed'),
    (1, 'Contactless', 52.40, 3870.92, '2024-12-14', '18:20', 'Fenwick Food Hall Newcastle', NULL, 'Contactless', NULL, 'Completed'),
    (2, 'Interest Credit', 38.54, 14788.54, '2024-12-31', '00:01', 'Quarterly interest payment', 'INT-Q4-24', 'Auto', NULL, 'Completed'),

    -- Customer 2 - Amara Osei (Current: account 3)
    (3, 'Deposit', 2450.00, 3325.30, '2024-10-01', '08:30', 'Salary - NHS Trust', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (3, 'Direct Debit', 725.00, 2600.30, '2024-10-05', '06:00', 'Rent payment - Grainger Lettings', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (3, 'Card Payment', 38.50, 2561.80, '2024-10-08', '12:40', 'Sainsburys - Jesmond', NULL, 'Contactless', NULL, 'Completed'),
    (3, 'Online Payment', 9.99, 2551.81, '2024-10-12', '21:00', 'Spotify Premium', 'SPOT-OCT', 'Online', NULL, 'Completed'),
    (3, 'Deposit', 2450.00, 5001.81, '2024-11-01', '08:30', 'Salary - NHS Trust', 'SAL-NOV24', 'Auto', NULL, 'Completed'),
    (3, 'Direct Debit', 725.00, 4276.81, '2024-11-05', '06:00', 'Rent payment - Grainger Lettings', 'DD-RENT-NOV', 'Auto', NULL, 'Completed'),
    (3, 'Card Payment', 156.00, 4120.81, '2024-11-15', '14:20', 'ASOS Online', 'ASOS-NOV', 'Online', NULL, 'Completed'),
    (3, 'Deposit', 2450.00, 6570.81, '2024-12-01', '08:30', 'Salary - NHS Trust', 'SAL-DEC24', 'Auto', NULL, 'Completed'),
    (3, 'Direct Debit', 725.00, 5845.81, '2024-12-05', '06:00', 'Rent payment - Grainger Lettings', 'DD-RENT-DEC', 'Auto', NULL, 'Completed'),
    (3, 'Card Payment', 320.00, 5525.81, '2024-12-08', '16:00', 'Flights - Ryanair', 'RYR-DEC', 'Online', NULL, 'Completed'),

    -- Customer 4 - Fatima Khan (Current: account 6, Savings: account 7)
    (6, 'Deposit', 3500.00, 4840.60, '2024-10-01', '09:00', 'Client invoice - Khan Design Studio', 'INV-1024', 'Online', NULL, 'Completed'),
    (6, 'Direct Debit', 950.00, 3890.60, '2024-10-04', '06:00', 'Rent payment - M3 Properties', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (6, 'Card Payment', 280.00, 3610.60, '2024-10-09', '11:00', 'Adobe Creative Suite Annual', 'ADOB-OCT', 'Online', NULL, 'Completed'),
    (6, 'Transfer Out', 1000.00, 2610.60, '2024-10-15', '10:30', 'Transfer to Crown Saver', 'TRF-FK1', 'Mobile', 7, 'Completed'),
    (7, 'Transfer In', 1000.00, 9200.00, '2024-10-15', '10:30', 'Transfer from Current Account', 'TRF-FK1', 'Mobile', 6, 'Completed'),
    (6, 'Deposit', 4200.00, 6810.60, '2024-11-01', '09:00', 'Client invoice - Khan Design Studio', 'INV-1124', 'Online', NULL, 'Completed'),
    (6, 'Direct Debit', 950.00, 5860.60, '2024-11-04', '06:00', 'Rent payment - M3 Properties', 'DD-RENT-NOV', 'Auto', NULL, 'Completed'),
    (6, 'Deposit', 2800.00, 8660.60, '2024-12-01', '09:00', 'Client invoice - Khan Design Studio', 'INV-1224', 'Online', NULL, 'Completed'),
    (6, 'Direct Debit', 950.00, 7710.60, '2024-12-04', '06:00', 'Rent payment - M3 Properties', 'DD-RENT-DEC', 'Auto', NULL, 'Completed'),

    -- Customer 8 - Claire Stephenson (Premium: account 13)
    (13, 'Deposit', 5500.00, 33950.00, '2024-10-01', '08:30', 'Salary - Goldman Sachs', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (13, 'Direct Debit', 1800.00, 32150.00, '2024-10-03', '06:00', 'Mortgage payment - Nationwide', 'DD-MORT-OCT', 'Auto', NULL, 'Completed'),
    (13, 'Card Payment', 450.00, 31700.00, '2024-10-06', '13:00', 'Harrods London', NULL, 'Contactless', NULL, 'Completed'),
    (13, 'Online Payment', 150.00, 31550.00, '2024-10-12', '19:00', 'Peloton Subscription', 'PEL-OCT', 'Online', NULL, 'Completed'),
    (13, 'Transfer Out', 2000.00, 29550.00, '2024-10-18', '10:00', 'Transfer to Fixed Rate Saver', 'TRF-CS1', 'Online', 14, 'Completed'),
    (14, 'Transfer In', 2000.00, 52000.00, '2024-10-18', '10:00', 'Transfer from Premium Account', 'TRF-CS1', 'Online', 13, 'Completed'),
    (13, 'Deposit', 5500.00, 35050.00, '2024-11-01', '08:30', 'Salary - Goldman Sachs', 'SAL-NOV24', 'Auto', NULL, 'Completed'),
    (13, 'Direct Debit', 1800.00, 33250.00, '2024-11-03', '06:00', 'Mortgage payment - Nationwide', 'DD-MORT-NOV', 'Auto', NULL, 'Completed'),
    (13, 'Card Payment', 1200.00, 32050.00, '2024-11-10', '14:30', 'British Airways - Flights', 'BA-NOV', 'Online', NULL, 'Completed'),
    (13, 'Deposit', 5500.00, 37550.00, '2024-12-01', '08:30', 'Salary - Goldman Sachs', 'SAL-DEC24', 'Auto', NULL, 'Completed'),
    (13, 'Direct Debit', 1800.00, 35750.00, '2024-12-03', '06:00', 'Mortgage payment - Nationwide', 'DD-MORT-DEC', 'Auto', NULL, 'Completed'),
    (13, 'Card Payment', 3200.00, 32550.00, '2024-12-12', '11:00', 'Selfridges - Christmas Shopping', NULL, 'Online', NULL, 'Completed'),
    (13, 'Fee Charge', 12.50, 32537.50, '2024-12-31', '00:01', 'Crown Plus monthly account fee', 'FEE-DEC24', 'Auto', NULL, 'Completed'),

    -- Customer 10 - Sophie Reed (Student: account 16)
    (16, 'Deposit', 500.00, 920.00, '2024-10-05', '12:00', 'Student Finance England', 'SFE-OCT24', 'Auto', NULL, 'Completed'),
    (16, 'Card Payment', 42.00, 878.00, '2024-10-07', '18:30', 'Dominos Pizza Newcastle', NULL, 'Contactless', NULL, 'Completed'),
    (16, 'Online Payment', 9.99, 868.01, '2024-10-10', '20:00', 'Netflix Subscription', 'NFLX-OCT', 'Online', NULL, 'Completed'),
    (16, 'Withdrawal', 50.00, 818.01, '2024-10-14', '22:30', 'ATM Withdrawal - Bigg Market', 'ATM-1014', 'ATM', NULL, 'Completed'),
    (16, 'Contactless', 4.50, 813.51, '2024-10-15', '08:00', 'Greggs - Haymarket', NULL, 'Contactless', NULL, 'Completed'),
    (16, 'Card Payment', 89.00, 724.51, '2024-11-02', '14:00', 'Amazon - Textbooks', 'AMZ-NOV', 'Online', NULL, 'Completed'),
    (16, 'Deposit', 150.00, 874.51, '2024-11-10', '17:00', 'Part-time work - Starbucks', 'PT-NOV', 'Auto', NULL, 'Completed'),
    (16, 'Contactless', 28.50, 846.01, '2024-11-18', '19:45', 'Nandos - Eldon Square', NULL, 'Contactless', NULL, 'Completed'),
    (16, 'Deposit', 500.00, 1346.01, '2024-12-05', '12:00', 'Student Finance England', 'SFE-DEC24', 'Auto', NULL, 'Completed'),
    (16, 'Card Payment', 250.00, 1096.01, '2024-12-10', '16:30', 'ASOS - Winter clothes', 'ASOS-DEC', 'Online', NULL, 'Completed'),

    -- Customer 16 - Hannah Murray (Premium: account 23, ISA: account 24)
    (23, 'Deposit', 6200.00, 48500.00, '2024-10-01', '08:30', 'Salary - Barclays Investment Bank', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (23, 'Direct Debit', 2200.00, 46300.00, '2024-10-03', '06:00', 'Mortgage payment - HSBC', 'DD-MORT-OCT', 'Auto', NULL, 'Completed'),
    (23, 'Transfer Out', 1500.00, 44800.00, '2024-10-08', '10:00', 'Transfer to ISA', 'TRF-HM1', 'Online', 24, 'Completed'),
    (24, 'Transfer In', 1500.00, 21500.00, '2024-10-08', '10:00', 'Transfer from Premium Account', 'TRF-HM1', 'Online', 23, 'Completed'),
    (23, 'Card Payment', 380.00, 44420.00, '2024-10-15', '12:30', 'Selfridges London', NULL, 'Contactless', NULL, 'Completed'),
    (23, 'Deposit', 6200.00, 50620.00, '2024-11-01', '08:30', 'Salary - Barclays Investment Bank', 'SAL-NOV24', 'Auto', NULL, 'Completed'),
    (23, 'Direct Debit', 2200.00, 48420.00, '2024-11-03', '06:00', 'Mortgage payment - HSBC', 'DD-MORT-NOV', 'Auto', NULL, 'Completed'),
    (23, 'Transfer Out', 1500.00, 46920.00, '2024-11-20', '10:00', 'Transfer to ISA', 'TRF-HM2', 'Online', 24, 'Completed'),
    (24, 'Transfer In', 1500.00, 23000.00, '2024-11-20', '10:00', 'Transfer from Premium Account', 'TRF-HM2', 'Online', 23, 'Completed'),
    (23, 'Deposit', 6200.00, 53120.00, '2024-12-01', '08:30', 'Salary - Barclays Investment Bank', 'SAL-DEC24', 'Auto', NULL, 'Completed'),
    (23, 'Direct Debit', 2200.00, 50920.00, '2024-12-03', '06:00', 'Mortgage payment - HSBC', 'DD-MORT-DEC', 'Auto', NULL, 'Completed'),
    (23, 'Card Payment', 2800.00, 48120.00, '2024-12-15', '14:00', 'Net-A-Porter - Christmas', NULL, 'Online', NULL, 'Completed'),
    (23, 'Fee Charge', 12.50, 48107.50, '2024-12-31', '00:01', 'Crown Plus monthly account fee', 'FEE-DEC24', 'Auto', NULL, 'Completed'),

    -- Additional diverse transactions for other customers
    (4, 'Deposit', 1200.00, 10120.75, '2024-10-01', '08:30', 'State Pension', 'PENS-OCT', 'Auto', NULL, 'Completed'),
    (4, 'Direct Debit', 95.00, 10025.75, '2024-10-08', '06:00', 'Yorkshire Water', 'DD-YW-OCT', 'Auto', NULL, 'Completed'),
    (4, 'Card Payment', 35.00, 9990.75, '2024-10-12', '10:30', 'Morrisons Leeds', NULL, 'Contactless', NULL, 'Completed'),
    (8, 'Deposit', 4200.00, 19870.80, '2024-10-01', '08:30', 'Salary - Scottish Government', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (8, 'Direct Debit', 1450.00, 18420.80, '2024-10-03', '06:00', 'Mortgage payment - RBS', 'DD-MORT-OCT', 'Auto', NULL, 'Completed'),
    (8, 'Card Payment', 85.00, 18335.80, '2024-10-10', '19:00', 'Royal Lyceum Theatre Edinburgh', NULL, 'Online', NULL, 'Completed'),
    (11, 'Deposit', 3100.00, 8530.90, '2024-10-01', '08:30', 'Salary - Airbus Bristol', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (11, 'Direct Debit', 875.00, 7655.90, '2024-10-04', '06:00', 'Rent payment - CJ Hole', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (15, 'Deposit', 2200.00, 3450.40, '2024-10-01', '08:30', 'Salary - Scottish Power', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (15, 'Direct Debit', 680.00, 2770.40, '2024-10-05', '06:00', 'Rent payment - Clyde Living', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (19, 'Deposit', 4500.00, 11280.30, '2024-10-01', '09:00', 'Client fees - Foster Consulting', 'INV-OCT24', 'Online', NULL, 'Completed'),
    (19, 'Direct Debit', 1100.00, 10180.30, '2024-10-03', '06:00', 'Mortgage payment - Bank of Scotland', 'DD-MORT-OCT', 'Auto', NULL, 'Completed'),
    (21, 'Deposit', 2750.00, 6310.40, '2024-10-01', '08:30', 'Salary - Jaguar Land Rover', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (21, 'Direct Debit', 780.00, 5530.40, '2024-10-04', '06:00', 'Rent payment - Let by RICS', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (25, 'Deposit', 3200.00, 8070.55, '2024-10-01', '08:30', 'Salary - ScottishPower', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (25, 'Direct Debit', 720.00, 7350.55, '2024-10-03', '06:00', 'Rent payment - CKD Galbraith', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (26, 'Deposit', 2000.00, 3680.90, '2024-10-01', '08:30', 'Salary - Sage Group', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (26, 'Direct Debit', 625.00, 3055.90, '2024-10-05', '06:00', 'Rent payment - Quayside Lettings', 'DD-RENT-OCT', 'Auto', NULL, 'Completed'),
    (29, 'Deposit', 2600.00, 5580.15, '2024-10-01', '08:30', 'Salary - PwC Manchester', 'SAL-OCT24', 'Auto', NULL, 'Completed'),
    (29, 'Direct Debit', 850.00, 4730.15, '2024-10-04', '06:00', 'Rent payment - Bruntwood', 'DD-RENT-OCT', 'Auto', NULL, 'Completed')
GO

-- ============================================================================
-- INSERT: Cards
-- ============================================================================
INSERT INTO Cards (account_id, customer_id, card_type, card_number_last4, expiry_date, daily_limit, contactless_enabled, status, issue_date)
VALUES
    (1,  1,  'Debit',  '4521', '2026-09-30', 500.00, 1, 'Active', '2023-09-15'),
    (3,  2,  'Debit',  '7832', '2026-06-30', 500.00, 1, 'Active', '2023-06-10'),
    (4,  3,  'Debit',  '1245', '2027-03-31', 500.00, 1, 'Active', '2024-03-20'),
    (6,  4,  'Debit',  '9087', '2026-01-31', 500.00, 1, 'Active', '2023-01-08'),
    (8,  5,  'Debit',  '3456', '2025-11-30', 1000.00, 1, 'Active', '2022-11-15'),
    (8,  5,  'Credit', '6789', '2026-11-30', 2000.00, 1, 'Active', '2023-11-15'),
    (10, 6,  'Debit',  '2341', '2026-03-31', 300.00, 1, 'Active', '2023-03-20'),
    (11, 7,  'Debit',  '5678', '2026-05-31', 500.00, 1, 'Active', '2023-05-12'),
    (13, 8,  'Debit',  '8901', '2025-07-31', 2000.00, 1, 'Active', '2022-07-03'),
    (13, 8,  'Credit', '2345', '2026-07-31', 5000.00, 1, 'Active', '2023-07-03'),
    (15, 9,  'Debit',  '6712', '2026-09-30', 300.00, 1, 'Active', '2023-09-10'),
    (16, 10, 'Debit',  '0198', '2027-08-31', 250.00, 1, 'Active', '2024-08-22'),
    (17, 11, 'Debit',  '3489', '2026-04-30', 500.00, 1, 'Active', '2023-04-05'),
    (18, 12, 'Debit',  '7654', '2027-02-28', 500.00, 1, 'Active', '2024-02-14'),
    (19, 13, 'Debit',  '0923', '2026-09-30', 1000.00, 1, 'Active', '2023-09-18'),
    (21, 14, 'Debit',  '4567', '2025-11-30', 500.00, 1, 'Active', '2022-11-01'),
    (22, 15, 'Debit',  '8012', '2027-04-30', 250.00, 1, 'Active', '2024-04-05'),
    (23, 16, 'Debit',  '1357', '2025-01-31', 2000.00, 1, 'Active', '2022-01-30'),
    (23, 16, 'Credit', '2468', '2026-01-31', 10000.00, 1, 'Active', '2023-01-30'),
    (25, 17, 'Debit',  '5791', '2026-08-31', 500.00, 1, 'Active', '2023-08-12'),
    (26, 18, 'Debit',  '3580', '2027-05-31', 500.00, 1, 'Active', '2024-05-20'),
    (27, 19, 'Debit',  '9246', '2025-03-31', 500.00, 1, 'Active', '2022-03-25'),
    (29, 20, 'Debit',  '6135', '2025-12-31', 500.00, 1, 'Active', '2022-12-08')
GO

-- ============================================================================
-- INSERT: Loans
-- ============================================================================
INSERT INTO Loans (customer_id, account_id, loan_officer_id, loan_type, principal_amount, interest_rate, term_months, monthly_repayment, outstanding_balance, start_date, end_date, status, missed_payments)
VALUES
    (1,  1,  6,  'Personal',       8000.00,   5.90, 36, 243.16, 4862.40, '2023-06-01', '2026-06-01', 'Active', 0),
    (4,  6,  7,  'Personal',       5000.00,   6.50, 24, 222.75, 2227.50, '2023-09-01', '2025-09-01', 'Active', 1),
    (5,  8,  6,  'Mortgage',     285000.00,   4.25, 300, 1540.00, 271500.00, '2020-01-15', '2045-01-15', 'Active', 0),
    (7,  11, 7,  'Car Finance',   18000.00,   7.20, 48, 432.50, 10380.00, '2022-11-01', '2026-11-01', 'Active', 0),
    (8,  13, 6,  'Mortgage',     450000.00,   3.85, 300, 2320.00, 422500.00, '2019-09-01', '2044-09-01', 'Active', 0),
    (9,  15, 7,  'Credit Builder', 1000.00,  19.90, 12, 92.42, 369.68, '2024-04-01', '2025-04-01', 'Active', 0),
    (13, 19, 6,  'Personal',      15000.00,   5.40, 48, 348.20, 9742.00, '2023-01-15', '2027-01-15', 'Active', 0),
    (14, 21, 16, 'Car Finance',   12000.00,   6.80, 36, 368.50, 5527.50, '2023-07-01', '2026-07-01', 'Active', 0),
    (16, 23, 6,  'Mortgage',     550000.00,   3.50, 300, 2720.00, 518000.00, '2019-03-01', '2044-03-01', 'Active', 0),
    (17, 25, 7,  'Personal',       6000.00,   6.10, 24, 266.20, 1597.20, '2023-10-01', '2025-10-01', 'Active', 0),
    (20, 29, 16, 'Personal',       3000.00,   8.90, 18, 180.50, 1083.00, '2024-03-01', '2025-09-01', 'Active', 2)
GO

-- ============================================================================
-- INSERT: Loan_Repayments (sample for first few loans)
-- ============================================================================
-- Note: loan_id depends on IDENTITY. First loan inserted = loan_id based on your server.
-- These use loan_id 1 (John Personal), 2 (Fatima Personal), 6 (Daniel Credit Builder)
INSERT INTO Loan_Repayments (loan_id, account_id, repayment_amount, principal_portion, interest_portion, repayment_date, due_date, status, days_late)
VALUES
    -- John Henderson - Personal Loan (loan 1, account 1)
    (1, 1, 243.16, 203.72, 39.44, '2024-10-01', '2024-10-01', 'Paid', 0),
    (1, 1, 243.16, 204.72, 38.44, '2024-11-01', '2024-11-01', 'Paid', 0),
    (1, 1, 243.16, 205.73, 37.43, '2024-12-01', '2024-12-01', 'Paid', 0),

    -- Fatima Khan - Personal Loan (loan 2, account 6)
    (2, 6, 222.75, 195.64, 27.11, '2024-10-01', '2024-10-01', 'Paid', 0),
    (2, 6, 222.75, 196.70, 26.05, '2024-11-01', '2024-11-01', 'Paid', 0),
    (2, 6, 0.00, 0.00, 0.00, '2024-12-01', '2024-12-01', 'Missed', 0),

    -- Daniel Mbeki - Credit Builder (loan 6, account 15)
    (6, 15, 92.42, 76.83, 15.59, '2024-10-01', '2024-10-01', 'Paid', 0),
    (6, 15, 92.42, 78.11, 14.31, '2024-11-01', '2024-11-01', 'Paid', 0),
    (6, 15, 92.42, 79.40, 13.02, '2024-12-05', '2024-12-01', 'Late', 4),

    -- Jessica Okonkwo - Personal Loan (loan 11, account 29)
    (11, 29, 180.50, 158.25, 22.25, '2024-10-01', '2024-10-01', 'Paid', 0),
    (11, 29, 0.00, 0.00, 0.00, '2024-11-01', '2024-11-01', 'Missed', 0),
    (11, 29, 180.50, 159.42, 21.08, '2024-12-08', '2024-12-01', 'Late', 7)
GO

-- ============================================================================
-- INSERT: Standing_Orders
-- ============================================================================
INSERT INTO Standing_Orders (account_id, payee_name, payee_account, payee_sort_code, amount, frequency, start_date, end_date, next_payment_date, reference, status)
VALUES
    (1,  'Newcastle City Council', '00112233', '30-12-45', 200.00, 'Monthly', '2020-04-01', NULL, '2025-01-15', 'Council Tax - NE1 6AE', 'Active'),
    (1,  'Northern Powergrid', '00223344', '40-15-22', 85.00, 'Monthly', '2021-01-01', NULL, '2025-01-01', 'Electricity bill', 'Active'),
    (3,  'Grainger Lettings', '00334455', '20-30-40', 725.00, 'Monthly', '2020-06-15', NULL, '2025-01-05', 'Rent - Flat 3 Jesmond Rd', 'Active'),
    (6,  'M3 Properties Ltd', '00445566', '11-22-33', 950.00, 'Monthly', '2021-02-01', NULL, '2025-01-04', 'Rent - Apt 12 Deansgate', 'Active'),
    (8,  'Royal Bank of Scotland', '00556677', '83-19-27', 1450.00, 'Monthly', '2020-01-15', NULL, '2025-01-03', 'Mortgage repayment', 'Active'),
    (13, 'Nationwide Building Soc', '00667788', '07-01-16', 1800.00, 'Monthly', '2019-09-01', NULL, '2025-01-03', 'Mortgage repayment', 'Active'),
    (16, 'Stagecoach North East', NULL, NULL, 55.00, 'Monthly', '2023-09-01', '2024-06-30', '2024-06-01', 'Student bus pass', 'Completed'),
    (23, 'HSBC Mortgage Services', '00778899', '40-02-50', 2200.00, 'Monthly', '2019-03-15', NULL, '2025-01-03', 'Mortgage repayment', 'Active'),
    (23, 'Bupa Health Insurance', '00889900', '20-45-12', 125.00, 'Monthly', '2020-01-01', NULL, '2025-01-01', 'Private health premium', 'Active'),
    (25, 'CKD Galbraith Lettings', '00990011', '80-22-60', 720.00, 'Monthly', '2021-01-01', NULL, '2025-01-03', 'Rent - Byres Road', 'Active'),
    (19, 'Bank of Scotland', '01100112', '80-11-45', 1100.00, 'Monthly', '2020-10-01', NULL, '2025-01-03', 'Mortgage repayment', 'Active'),
    (1,  'Henderson Family', '01122334', '20-45-67', 300.00, 'Monthly', '2024-01-01', NULL, '2025-01-10', 'Family savings contribution', 'Active')
GO

-- ============================================================================
-- INSERT: Fraud_Alerts
-- ============================================================================
INSERT INTO Fraud_Alerts (account_id, transaction_id, card_id, alert_type, severity, description, investigation_status, assigned_to, alert_date, resolved_date, resolution_notes)
VALUES
    -- Note: transaction_id and card_id depend on IDENTITY. Using approximate values.
    (15, NULL, 11, 'Unusual Transaction', 'Medium', 'Multiple small transactions in rapid succession at different merchants within 10 minutes. Pattern inconsistent with account history.', 'Resolved', 11, '2024-10-20 14:30:00', '2024-10-21 09:00:00', 'Customer confirmed transactions. Was Christmas shopping at Buchanan Galleries.'),
    (10, NULL, 7, 'Rapid Spending', 'High', 'Account spent 85% of monthly average in 48 hours. Three large online transactions from unfamiliar merchants.', 'Resolved', 12, '2024-11-05 08:15:00', '2024-11-06 14:30:00', 'Customer confirmed purchases. Sales event spending.'),
    (6, NULL, 4, 'Location Mismatch', 'High', 'Card used in London while customer phone location shows Manchester. Two transactions 200 miles apart within 30 minutes.', 'Under Review', 11, '2024-11-18 16:45:00', NULL, NULL),
    (13, NULL, 10, 'Large Withdrawal', 'Medium', 'Credit card cash advance of 3000 at ATM. Unusual for this customer profile - first ever cash advance.', 'Resolved', 12, '2024-11-22 10:00:00', '2024-11-22 16:00:00', 'False positive. Customer made advance for property deposit.'),
    (29, NULL, 23, 'Card Not Present', 'High', 'Three declined online transactions followed by a successful 450 transaction at unfamiliar overseas merchant.', 'Escalated', 11, '2024-12-03 02:30:00', NULL, NULL),
    (16, NULL, 12, 'Multiple Failed Logins', 'Critical', 'Seven failed mobile banking login attempts from unrecognised device and IP address. Possible account takeover attempt.', 'Resolved', 12, '2024-12-08 03:15:00', '2024-12-08 10:30:00', 'Student phone was stolen. Card blocked and replacement issued. No unauthorised transactions.'),
    (26, NULL, 21, 'Unusual Transaction', 'Low', 'First international transaction on account. Online purchase from US-based retailer for 180.', 'Resolved', 11, '2024-12-10 19:00:00', '2024-12-11 08:00:00', 'Customer confirmed. Christmas gift from American website.'),
    (23, NULL, 19, 'Large Withdrawal', 'Medium', 'Single card payment of 2800. Exceeds typical single transaction for this customer by 40%.', 'False Positive', 12, '2024-12-15 14:10:00', '2024-12-15 15:00:00', 'High-value customer. Christmas shopping at Net-A-Porter consistent with seasonal pattern.')
GO

