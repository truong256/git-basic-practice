-- Bai tap: INSERT INTO - QuanLySinhVien
-- Muc tieu: Them du lieu vao cac bang bang cau lenh INSERT INTO.
-- Yeu cau: Chay file sql/QuanLySinhVien.sql truoc neu CSDL chua duoc tao.

USE QuanLySinhVien;

-- =========================================================
-- 1. THEM DU LIEU VAO BANG Class
-- =========================================================

INSERT INTO Class
VALUES (1, 'A1', '2008-12-20', 1);

INSERT INTO Class
VALUES (2, 'A2', '2008-12-22', 1);

INSERT INTO Class
VALUES (3, 'B3', CURRENT_DATE, 0);

-- =========================================================
-- 2. THEM DU LIEU VAO BANG Student
-- StudentID la AUTO_INCREMENT nen khong can truyen vao.
-- =========================================================

INSERT INTO Student (StudentName, Address, Phone, Status, ClassID)
VALUES ('Hung', 'Ha Noi', '0912113113', 1, 1);

INSERT INTO Student (StudentName, Address, Status, ClassID)
VALUES ('Hoa', 'Hai phong', 1, 1);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassID)
VALUES ('Manh', 'HCM', '0123123123', 0, 2);

-- =========================================================
-- 3. THEM DU LIEU VAO BANG Subject
-- =========================================================

INSERT INTO Subject
VALUES
    (1, 'CF', 5, 1),
    (2, 'C', 6, 1),
    (3, 'HDJ', 5, 1),
    (4, 'RDBMS', 10, 1);

-- =========================================================
-- 4. THEM DU LIEU VAO BANG Mark
-- MarkID la AUTO_INCREMENT nen khong can truyen vao.
-- =========================================================

INSERT INTO Mark (SubID, StudentID, Mark, ExamTimes)
VALUES
    (1, 1, 8, 1),
    (1, 2, 10, 2),
    (2, 1, 12, 1);

-- =========================================================
-- 5. KIEM TRA DU LIEU SAU KHI INSERT
-- =========================================================

SELECT * FROM Class;
SELECT * FROM Student;
SELECT * FROM Subject;
SELECT * FROM Mark;
