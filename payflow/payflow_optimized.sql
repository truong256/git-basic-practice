-- =========================================================
-- PAYFLOW - QUERY OPTIMIZATION WITH EXPLAIN & SARGABLE
-- File: payflow_optimized.sql
-- Target: MySQL 8.0+
-- =========================================================

DROP DATABASE IF EXISTS payflow_db;
CREATE DATABASE payflow_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE payflow_db;

-- =========================================================
-- 1. LEGACY TABLE
-- =========================================================

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20),
    created_at DATETIME
);

-- =========================================================
-- 2. GENERATE 100,000 SAMPLE TRANSACTIONS
-- Giup EXPLAIN de quan sat hon trong moi truong thuc hanh.
-- Production scenario cua de bai co hon 5,000,000 dong.
-- =========================================================

CREATE TEMPORARY TABLE digits (d TINYINT PRIMARY KEY);

INSERT INTO digits (d)
VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

INSERT INTO Transactions (
    user_id,
    amount,
    transaction_type,
    created_at
)
SELECT
    MOD(n, 10000) + 1 AS user_id,
    10000.00 + MOD(n, 1000) * 100.00 AS amount,
    CASE MOD(n, 3)
        WHEN 0 THEN 'DEPOSIT'
        WHEN 1 THEN 'WITHDRAW'
        ELSE 'TRANSFER'
    END AS transaction_type,
    DATE_ADD('2025-01-01 00:00:00', INTERVAL n HOUR) AS created_at
FROM (
    SELECT
        d1.d
        + d2.d * 10
        + d3.d * 100
        + d4.d * 1000
        + d5.d * 10000 AS n
    FROM digits d1
    CROSS JOIN digits d2
    CROSS JOIN digits d3
    CROSS JOIN digits d4
    CROSS JOIN digits d5
) AS numbers;

DROP TEMPORARY TABLE digits;

ANALYZE TABLE Transactions;

-- =========================================================
-- 3. LEGACY QUERY - NON-SARGABLE
-- YEAR() va MONTH() boc quanh created_at.
-- Khong co secondary index => du kien type = ALL.
-- =========================================================

EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;

-- =========================================================
-- 4. ADD COMPOSITE B-TREE INDEX
-- transaction_type dat truoc vi truy van loc equality (=).
-- created_at dat sau de MySQL tiep tuc dung range tren cung index.
-- =========================================================

CREATE INDEX idx_type_date
ON Transactions (transaction_type, created_at);

ANALYZE TABLE Transactions;

-- =========================================================
-- 5. OPTIMIZED QUERY - SARGABLE
-- Loai bo YEAR() / MONTH().
-- Dung khoang [2026-06-01, 2026-07-01).
-- Du kien EXPLAIN type = range va key = idx_type_date.
-- =========================================================

EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- =========================================================
-- 6. RUN THE OPTIMIZED REPORT
-- =========================================================

SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- =========================================================
-- 7. OPTIONAL: COMPARE BOTH PLANS AFTER INDEX EXISTS
-- Truy van cu van la Non-SARGable doi voi created_at.
-- MySQL co the dung phan dau cua composite index cho
-- transaction_type, nhung khong the range-seek created_at.
-- =========================================================

EXPLAIN
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;

-- =========================================================
-- 8. OPTIONAL: ACTUAL EXECUTION DETAILS (MySQL 8.0.18+)
-- EXPLAIN ANALYZE thuc thi cau lenh va hien thi actual time/rows.
-- Bo comment de chay khi can.
-- =========================================================

-- EXPLAIN ANALYZE
-- SELECT SUM(amount) AS total_deposit
-- FROM Transactions
-- WHERE transaction_type = 'DEPOSIT'
--   AND created_at >= '2026-06-01 00:00:00'
--   AND created_at <  '2026-07-01 00:00:00';

-- =========================================================
-- GHI CHU DOC EXPLAIN
-- type = ALL   : Full Table Scan.
-- type = range : Quet mot khoang khoa tren B-Tree index.
-- possible_keys: Index co the su dung.
-- key          : Index MySQL thuc su chon.
-- rows         : So dong optimizer uoc tinh can doc.
-- Extra        : Thong tin bo sung nhu Using index condition.
--
-- Luu y:
-- Voi bang rat nho hoac du lieu phan bo khac, optimizer co the
-- chon full scan vi no re hon. Ket qua EXPLAIN can duoc danh gia
-- tren du lieu du lon va gan voi production.
-- =========================================================
