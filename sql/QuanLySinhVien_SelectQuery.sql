-- Bai tap: SELECT QUERY - QuanLySinhVien
-- Muc tieu: Su dung cac cau lenh truy van trong MySQL.
-- Yeu cau: Chay QuanLySinhVien.sql va QuanLySinhVien_InsertData.sql truoc.

USE QuanLySinhVien;

-- 1. Hien thi danh sach tat ca hoc vien
SELECT *
FROM Student;

-- 2. Hien thi danh sach hoc vien dang theo hoc
-- Status = 1/TRUE: dang hoc
SELECT *
FROM Student
WHERE Status = TRUE;

-- 3. Hien thi danh sach mon hoc co thoi gian hoc nho hon 10 gio
SELECT *
FROM Subject
WHERE Credit < 10;

-- 4. Hien thi danh sach hoc vien lop A1
SELECT
    S.StudentID,
    S.StudentName,
    C.ClassName
FROM Student AS S
JOIN Class AS C
    ON S.ClassID = C.ClassID
WHERE C.ClassName = 'A1';

-- 5. Hien thi diem mon CF cua cac hoc vien
SELECT
    S.StudentID,
    S.StudentName,
    Sub.SubName,
    M.Mark
FROM Student AS S
JOIN Mark AS M
    ON S.StudentID = M.StudentID
JOIN Subject AS Sub
    ON M.SubID = Sub.SubID
WHERE Sub.SubName = 'CF';
