-- Bai tap: Tao CSDL QuanLyDiemThi
-- Muc tieu: Tao bang bang cau lenh SQL voi day du khoa chinh va khoa ngoai.

-- Buoc 1: Tao co so du lieu
CREATE DATABASE QuanLyDiemThi;

-- Buoc 2: Chon co so du lieu
USE QuanLyDiemThi;

-- Buoc 3: Tao bang HocSinh
CREATE TABLE HocSinh (
    MaHS VARCHAR(20) PRIMARY KEY,
    TenHS VARCHAR(50),
    NgaySinh DATETIME,
    Lop VARCHAR(20),
    GT VARCHAR(20)
);

-- Buoc 4: Tao bang MonHoc
CREATE TABLE MonHoc (
    MaMH VARCHAR(20) PRIMARY KEY,
    TenMH VARCHAR(50),
    MaGV VARCHAR(20)
);

-- Buoc 5: Tao bang BangDiem
-- Bang trung gian cho quan he nhieu-nhieu giua HocSinh va MonHoc.
CREATE TABLE BangDiem (
    MaHS VARCHAR(20),
    MaMH VARCHAR(20),
    DiemThi INT,
    NgayKT DATETIME,
    PRIMARY KEY (MaHS, MaMH),
    FOREIGN KEY (MaHS) REFERENCES HocSinh(MaHS),
    FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
);

-- Buoc 6: Tao bang GiaoVien
CREATE TABLE GiaoVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    TenGV VARCHAR(50),
    SDT VARCHAR(10)
);

-- Buoc 7: Bo sung khoa ngoai MaGV cho bang MonHoc
ALTER TABLE MonHoc
ADD CONSTRAINT FK_MaGV
FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV);
