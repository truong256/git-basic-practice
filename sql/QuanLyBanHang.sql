-- Bai tap: QuanLyBanHang
-- Muc tieu: Tao co so du lieu, tao bang va su dung cac rang buoc khoa.

CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- 1. Bang Customer: luu danh sach khach hang
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    cName VARCHAR(25),
    cAge TINYINT
);

-- 2. Bang Product: luu danh sach san pham va gia
CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

-- 3. Bang Order: luu hoa don cua tung khach hang
-- ORDER la tu khoa trong MySQL, vi vay can dat ten bang trong dau backtick.
CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- 4. Bang OrderDetail: luu chi tiet san pham trong tung hoa don
CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    CONSTRAINT fk_orderdetail_order
        FOREIGN KEY (oID) REFERENCES `Order`(oID),
    CONSTRAINT fk_orderdetail_product
        FOREIGN KEY (pID) REFERENCES Product(pID)
);
