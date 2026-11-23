-- ============================================================================
-- DBMS Experiment 8: Transactions, Savepoints, Isolation Levels & Concurrency
-- ============================================================================

-- 1. Create and populate the account table
CREATE TABLE Bank_Account (
    Account_ID     INT PRIMARY KEY,
    Account_Holder VARCHAR(50),
    Balance        DECIMAL(10,2)
);

INSERT INTO Bank_Account
VALUES
(101, 'Rahul Sharma', 50000.00),
(102, 'Priya Singh',  30000.00),
(103, 'Amit Kumar',   40000.00);

SELECT * FROM Bank_Account;

-- 2. Successful transfer (COMMIT)
START TRANSACTION;

UPDATE Bank_Account SET Balance = Balance - 5000 WHERE Account_ID = 101;
UPDATE Bank_Account SET Balance = Balance + 5000 WHERE Account_ID = 102;

COMMIT;
SELECT * FROM Bank_Account;

-- 3. Failed transfer (ROLLBACK)
START TRANSACTION;

UPDATE Bank_Account SET Balance = Balance - 10000 WHERE Account_ID = 101;
UPDATE Bank_Account SET Balance = Balance + 10000 WHERE Account_ID = 103;

ROLLBACK;
SELECT * FROM Bank_Account;

-- 4. Partial failure with SAVEPOINT
START TRANSACTION;

UPDATE Bank_Account SET Balance = Balance - 3000 WHERE Account_ID = 101;
SAVEPOINT transfer_point;

UPDATE Bank_Account SET Balance = Balance + 3000 WHERE Account_ID = 102;
ROLLBACK TO transfer_point;

COMMIT;
SELECT * FROM Bank_Account;

-- 5. Savepoint with corrective action
START TRANSACTION;

UPDATE Bank_Account SET Balance = Balance - 2000 WHERE Account_ID = 101;
SAVEPOINT before_second_transfer;

UPDATE Bank_Account SET Balance = Balance + 2000 WHERE Account_ID = 102;
ROLLBACK TO before_second_transfer;

UPDATE Bank_Account SET Balance = Balance + 2000 WHERE Account_ID = 103;

COMMIT;
SELECT * FROM Bank_Account;

-- 6. Isolation levels
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

-- 7. Concurrent update on the same row
-- Session A:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
UPDATE Bank_Account SET Balance = Balance - 5000 WHERE Account_ID = 101;
COMMIT;

-- Session B:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
UPDATE Bank_Account SET Balance = Balance - 3000 WHERE Account_ID = 101;
COMMIT;

SELECT * FROM Bank_Account WHERE Account_ID = 101;

-- ============================================================================
-- Two-Session Demonstration of Concurrency Anomalies
-- ============================================================================

-- A. Dirty read (READ UNCOMMITTED)
-- Step 1 (Session A):
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
-- Step 2 (Session B):
START TRANSACTION;
UPDATE Bank_Account SET Balance = Balance - 5000 WHERE Account_ID = 101;
-- Step 3 (Session A):
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
-- Step 4 (Session B):
ROLLBACK;
-- Step 5 (Session A):
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;

-- B. Non-repeatable read (READ COMMITTED vs REPEATABLE READ)
-- Step 1 (Session A):
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
-- Step 2 (Session B):
UPDATE Bank_Account SET Balance = Balance - 5000 WHERE Account_ID = 101;
-- Step 3 (Session A):
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

-- C. Phantom read
-- Step 1 (Session A):
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT COUNT(*) FROM Bank_Account WHERE Balance > 30000;
-- Step 2 (Session B):
INSERT INTO Bank_Account VALUES (104, 'Neha Verma', 60000);
-- Step 3 (Session A):
SELECT COUNT(*) FROM Bank_Account WHERE Balance > 30000;
COMMIT;

-- D. Lost update and its prevention
-- Lost update pattern:
-- Step 1 (Session A):
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
-- Step 2 (Session B):
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
-- Step 3 (Session A):
UPDATE Bank_Account SET Balance = 35000 WHERE Account_ID = 101;
COMMIT;
-- Step 4 (Session B):
UPDATE Bank_Account SET Balance = 37000 WHERE Account_ID = 101;
COMMIT;

-- Fix (i): lock the row when reading it
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101 FOR UPDATE;
UPDATE Bank_Account SET Balance = Balance - 3000 WHERE Account_ID = 101;
COMMIT;

-- Fix (ii): atomic relative update
UPDATE Bank_Account SET Balance = Balance - 3000 WHERE Account_ID = 101;
