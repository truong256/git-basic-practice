-- =========================================================
-- FLASHMART REPORTS
-- Muc tieu: Phan biet INNER JOIN, LEFT JOIN va Anti-Join
-- MySQL 8.0+
-- =========================================================

DROP DATABASE IF EXISTS flashmart_db;
CREATE DATABASE flashmart_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE flashmart_db;

-- =========================================================
-- 1. TAO BANG
-- =========================================================

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- 2. DU LIEU MAU
-- =========================================================

INSERT INTO Customers (customer_id, name)
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie');

INSERT INTO Products (product_id, product_name)
VALUES
    (101, 'Laptop'),
    (102, 'Mouse'),
    (103, 'Keyboard');

INSERT INTO Orders (order_id, customer_id, product_id)
VALUES
    (1001, 1, 101),
    (1002, 1, 102),
    (1003, 2, 101);

-- =========================================================
-- 3. BAO CAO MARKETING
-- YEU CAU:
-- - Giu tat ca khach hang o bang Customers.
-- - Dem so don hang cua tung nguoi.
-- - Khach chua mua hang van phai xuat hien voi total_orders = 0.
-- =========================================================

SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY c.customer_id;

-- Ket qua mong doi:
-- 1 | Alice   | 2
-- 2 | Bob     | 1
-- 3 | Charlie | 0

-- =========================================================
-- 4. DANH SACH KHACH HANG CHUA TUNG MUA HANG
-- Anti-Join de Marketing gui voucher.
-- =========================================================

SELECT
    c.customer_id,
    c.name
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

-- Ket qua mong doi:
-- 3 | Charlie

-- =========================================================
-- 5. BAO CAO KHO VAN
-- Anti-Join: giu tat ca Products, sau do lay cac san pham
-- khong co dong Orders tuong ung.
-- =========================================================

SELECT
    p.product_id,
    p.product_name
FROM Products AS p
LEFT JOIN Orders AS o
    ON p.product_id = o.product_id
WHERE o.order_id IS NULL
ORDER BY p.product_id;

-- Ket qua mong doi:
-- 103 | Keyboard

-- =========================================================
-- 6. DOI CHIEU SO DONG
-- =========================================================

SELECT COUNT(*) AS total_customers
FROM Customers;

SELECT COUNT(*) AS total_unsold_products
FROM Products AS p
LEFT JOIN Orders AS o
    ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
