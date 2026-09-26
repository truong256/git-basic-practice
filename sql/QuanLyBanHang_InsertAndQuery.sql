-- Bai tap: INSERT va truy van - QuanLyBanHang
-- Muc tieu: Them du lieu va su dung cac cau lenh truy van MySQL.
-- Yeu cau: Chay file sql/QuanLyBanHang.sql truoc de tao CSDL va cac bang.

USE QuanLyBanHang;

-- =========================================================
-- 1. THEM DU LIEU VAO BANG Customer
-- =========================================================

INSERT INTO Customer (cID, cName, cAge)
VALUES
    (1, 'Minh Quan', 10),
    (2, 'Ngoc Oanh', 20),
    (3, 'Hong Ha', 50);

-- =========================================================
-- 2. THEM DU LIEU VAO BANG Order
-- oTotalPrice de NULL theo du lieu de bai.
-- =========================================================

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice)
VALUES
    (1, 1, '2006-03-21', NULL),
    (2, 2, '2006-03-23', NULL),
    (3, 1, '2006-03-16', NULL);

-- =========================================================
-- 3. THEM DU LIEU VAO BANG Product
-- =========================================================

INSERT INTO Product (pID, pName, pPrice)
VALUES
    (1, 'May Giat', 3),
    (2, 'Tu Lanh', 5),
    (3, 'Dieu Hoa', 7),
    (4, 'Quat', 1),
    (5, 'Bep Dien', 2);

-- =========================================================
-- 4. THEM DU LIEU VAO BANG OrderDetail
-- =========================================================

INSERT INTO OrderDetail (oID, pID, odQTY)
VALUES
    (1, 1, 3),
    (1, 3, 7),
    (1, 4, 2),
    (2, 1, 1),
    (3, 1, 8),
    (2, 5, 4),
    (2, 3, 3);

-- =========================================================
-- 5. HIEN THI oID, oDate, oPrice CUA TAT CA HOA DON
-- Cot thuc te trong schema la oTotalPrice, dat alias la oPrice.
-- =========================================================

SELECT
    oID,
    oDate,
    oTotalPrice AS oPrice
FROM `Order`;

-- =========================================================
-- 6. DANH SACH KHACH HANG DA MUA HANG VA SAN PHAM HO DA MUA
-- =========================================================

SELECT DISTINCT
    c.cID,
    c.cName,
    p.pID,
    p.pName
FROM Customer AS c
JOIN `Order` AS o
    ON c.cID = o.cID
JOIN OrderDetail AS od
    ON o.oID = od.oID
JOIN Product AS p
    ON od.pID = p.pID
ORDER BY
    c.cID,
    p.pID;

-- =========================================================
-- 7. TEN CAC KHACH HANG KHONG MUA BAT KY SAN PHAM NAO
-- LEFT JOIN + IS NULL de tim khach hang khong co chi tiet mua hang.
-- =========================================================

SELECT
    c.cName
FROM Customer AS c
LEFT JOIN `Order` AS o
    ON c.cID = o.cID
LEFT JOIN OrderDetail AS od
    ON o.oID = od.oID
WHERE od.oID IS NULL
ORDER BY c.cID;

-- Ket qua mong doi: Hong Ha

-- =========================================================
-- 8. MA HOA DON, NGAY BAN VA GIA TIEN TUNG HOA DON
-- Gia hoa don = SUM(odQTY * pPrice)
-- =========================================================

SELECT
    o.oID,
    o.oDate,
    COALESCE(SUM(od.odQTY * p.pPrice), 0) AS oPrice
FROM `Order` AS o
LEFT JOIN OrderDetail AS od
    ON o.oID = od.oID
LEFT JOIN Product AS p
    ON od.pID = p.pID
GROUP BY
    o.oID,
    o.oDate
ORDER BY o.oID;

-- Ket qua mong doi voi du lieu mau:
-- Hoa don 1: 60
-- Hoa don 2: 32
-- Hoa don 3: 24
