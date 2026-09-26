-- Bai tap: Tao CSDL QuanLySinhVien
-- Muc tieu: Tao co so du lieu, tao bang va su dung cac rang buoc.

-- Buoc 1: Tao co so du lieu
CREATE DATABASE QuanLySinhVien;

-- Buoc 2: Chon co so du lieu
USE QuanLySinhVien;

-- Buoc 3: Tao bang Class
CREATE TABLE Class (
    ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

-- Buoc 4: Tao bang Student
CREATE TABLE Student (
    StudentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);

-- Buoc 5: Tao bang Subject
CREATE TABLE Subject (
    SubID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit >= 1),
    Status BIT DEFAULT 1
);

-- Buoc 6: Tao bang Mark
CREATE TABLE Mark (
    MarkID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubID INT NOT NULL,
    StudentID INT NOT NULL,
    Mark FLOAT DEFAULT 0 CHECK (Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubID, StudentID),
    FOREIGN KEY (SubID) REFERENCES Subject(SubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);
