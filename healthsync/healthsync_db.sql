-- =========================================================
-- HEALTHSYNC - OPTIMIZED DATABASE
-- File: healthsync_db.sql
-- MySQL 8.0+
-- =========================================================

CREATE DATABASE IF NOT EXISTS healthsync_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE healthsync_db;

-- Tao lai schema de script co the chay lai nhieu lan trong moi truong thuc hanh.
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;

-- 1. BENH NHAN
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 2. BAC SI
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 3. LICH HEN
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,

    status ENUM(
        'PENDING',
        'CONFIRMED',
        'CHECKED_IN',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',

    deposit_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_deposit_non_negative
        CHECK (deposit_amount >= 0),

    CONSTRAINT chk_penalty_non_negative
        CHECK (penalty_fee >= 0),

    CONSTRAINT chk_penalty_not_greater_than_deposit
        CHECK (penalty_fee <= deposit_amount),

    CONSTRAINT chk_cancel_information
        CHECK (
            (status = 'CANCELLED' AND cancel_reason IS NOT NULL)
            OR
            (status <> 'CANCELLED' AND cancel_reason IS NULL AND penalty_fee = 0)
        )
);

-- 4. DON THUOC
-- Chon quan he 1-1: moi lich hen hoan tat toi da co mot don thuoc.
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_prescriptions_appointment UNIQUE (appointment_id),

    CONSTRAINT fk_prescriptions_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- 5. TRIGGER BAO VE LOGIC NGHIEP VU
-- Chi cho phep ke don thuoc khi lich hen da COMPLETED.
DROP TRIGGER IF EXISTS trg_prescription_requires_completed;

DELIMITER //

CREATE TRIGGER trg_prescription_requires_completed
BEFORE INSERT ON Prescriptions
FOR EACH ROW
BEGIN
    DECLARE current_status VARCHAR(20);

    SELECT status
    INTO current_status
    FROM Appointments
    WHERE appointment_id = NEW.appointment_id;

    IF current_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment does not exist';
    END IF;

    IF current_status <> 'COMPLETED' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prescription is allowed only for COMPLETED appointments';
    END IF;
END//

DELIMITER ;

-- =========================================================
-- DU LIEU MO PHONG NGHIEP VU
-- =========================================================

-- Du lieu co so
INSERT INTO Patients (full_name, phone)
VALUES
    ('Nguyen Van A', '0912345678'),
    ('Tran Thi B', '0987654321');

INSERT INTO Doctors (full_name, specialty)
VALUES
    ('Dr. Le Minh', 'Noi tong quat');

-- ---------------------------------------------------------
-- KICH BAN 1: KHAM THANH CONG
-- PENDING -> CONFIRMED -> CHECKED_IN -> COMPLETED
-- Coc: 500.000 VND
-- ---------------------------------------------------------

INSERT INTO Appointments (
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount
)
VALUES (
    1,
    1,
    '2026-10-01 09:00:00',
    'PENDING',
    500000.00
);

SET @appointment_success_id = LAST_INSERT_ID();

UPDATE Appointments
SET status = 'CONFIRMED'
WHERE appointment_id = @appointment_success_id;

UPDATE Appointments
SET status = 'CHECKED_IN'
WHERE appointment_id = @appointment_success_id;

UPDATE Appointments
SET status = 'COMPLETED'
WHERE appointment_id = @appointment_success_id;

INSERT INTO Prescriptions (
    appointment_id,
    medication_details,
    issued_date
)
VALUES (
    @appointment_success_id,
    'Paracetamol 500mg: 2 vien/ngay sau an, dung trong 3 ngay.',
    '2026-10-01 10:15:00'
);

-- ---------------------------------------------------------
-- KICH BAN 2: HUY LICH VA TINH PHI PHAT
-- CONFIRMED -> CANCELLED
-- Coc: 300.000 VND
-- Phat: 150.000 VND
-- ---------------------------------------------------------

INSERT INTO Appointments (
    patient_id,
    doctor_id,
    appointment_date,
    status,
    deposit_amount
)
VALUES (
    2,
    1,
    '2026-10-02 14:00:00',
    'CONFIRMED',
    300000.00
);

SET @appointment_cancelled_id = LAST_INSERT_ID();

UPDATE Appointments
SET
    status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = @appointment_cancelled_id;

-- =========================================================
-- TRUY VAN KIEM TRA KET QUA
-- =========================================================

-- 1. Kiem tra trang thai, tien coc, tien phat va tien coc con lai.
SELECT
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_date,
    a.status,
    a.deposit_amount,
    a.penalty_fee,
    (a.deposit_amount - a.penalty_fee) AS remaining_deposit,
    a.cancel_reason
FROM Appointments a
JOIN Patients p ON p.patient_id = a.patient_id
JOIN Doctors d ON d.doctor_id = a.doctor_id
ORDER BY a.appointment_id;

-- 2. Lay danh sach benh nhan da kham xong va chi tiet don thuoc.
SELECT
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_date,
    a.status,
    pr.prescription_id,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p ON p.patient_id = a.patient_id
JOIN Doctors d ON d.doctor_id = a.doctor_id
JOIN Prescriptions pr ON pr.appointment_id = a.appointment_id
WHERE a.status = 'COMPLETED'
ORDER BY pr.issued_date DESC;

-- Thu trigger (de comment de script chay tron ven):
-- INSERT INTO Prescriptions (appointment_id, medication_details)
-- VALUES (@appointment_cancelled_id, 'Du lieu sai logic');
-- Cau lenh tren phai bi trigger tu choi vi lich hen la CANCELLED.
