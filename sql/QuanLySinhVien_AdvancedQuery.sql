-- Bai tap: Truy van MySQL nang cao - QuanLySinhVien
-- Muc tieu: Su dung LIKE, MONTH, BETWEEN, UPDATE, JOIN va ORDER BY.
-- Yeu cau: Chay QuanLySinhVien.sql va QuanLySinhVien_InsertData.sql truoc.

USE QuanLySinhVien;

-- 1. Hien thi tat ca sinh vien co ten bat dau bang ky tu 'H'
SELECT *
FROM Student
WHERE StudentName LIKE 'H%';

-- 2. Hien thi thong tin cac lop hoc co thoi gian bat dau vao thang 12
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- 3. Hien thi tat ca mon hoc co Credit trong khoang tu 3 den 5
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- 4. Thay doi ClassID cua sinh vien co ten 'Hung' thanh 2
UPDATE Student
SET ClassID = 2
WHERE StudentName = 'Hung';

-- Kiem tra lai du lieu sau khi cap nhat
SELECT
    StudentID,
    StudentName,
    ClassID
FROM Student
WHERE StudentName = 'Hung';

-- 5. Hien thi StudentName, SubName, Mark
-- Sap xep Mark giam dan; neu trung diem thi sap xep StudentName tang dan
SELECT
    S.StudentName,
    Sub.SubName,
    M.Mark
FROM Student AS S
JOIN Mark AS M
    ON S.StudentID = M.StudentID
JOIN Subject AS Sub
    ON M.SubID = Sub.SubID
ORDER BY
    M.Mark DESC,
    S.StudentName ASC;
