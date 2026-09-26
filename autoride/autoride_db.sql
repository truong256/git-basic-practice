-- =========================================================
-- AUTORIDE - DATABASE UPGRADE
-- File: autoride_db.sql
-- MySQL 8.0+
-- =========================================================

-- Reset chi dung cho moi truong thuc hanh de script co the chay tu dau.
DROP DATABASE IF EXISTS autoride_db;
CREATE DATABASE autoride_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE autoride_db;

-- =========================================================
-- PHAN 1. LEGACY DATABASE
-- =========================================================

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    status VARCHAR(50) DEFAULT 'BOOKED',

    CONSTRAINT fk_rentals_car_legacy
        FOREIGN KEY (car_id)
        REFERENCES Cars(car_id)
);

-- =========================================================
-- PHAN 2. NANG CAP BANG RENTALS BANG ALTER TABLE
-- =========================================================

-- Chuyen status tu VARCHAR sang ENUM de gioi han cac trang thai hop le.
ALTER TABLE Rentals
    MODIFY COLUMN status ENUM(
        'BOOKED',
        'ACTIVE',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'BOOKED';

-- Bo sung cac truong tai chinh.
ALTER TABLE Rentals
    ADD COLUMN security_deposit DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN late_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    ADD COLUMN damage_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00;

-- Rang buoc dam bao du lieu tai chinh hop le.
ALTER TABLE Rentals
    ADD CONSTRAINT chk_security_deposit_non_negative
        CHECK (security_deposit >= 0),
    ADD CONSTRAINT chk_late_fee_non_negative
        CHECK (late_fee >= 0),
    ADD CONSTRAINT chk_damage_fee_non_negative
        CHECK (damage_fee >= 0),
    ADD CONSTRAINT chk_total_fee_not_greater_than_deposit
        CHECK (late_fee + damage_fee <= security_deposit);

-- Tang do chat cua khoa ngoai Cars -> Rentals.
ALTER TABLE Rentals
    DROP FOREIGN KEY fk_rentals_car_legacy,
    MODIFY COLUMN car_id INT NOT NULL,
    ADD CONSTRAINT fk_rentals_car
        FOREIGN KEY (car_id)
        REFERENCES Cars(car_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

-- =========================================================
-- PHAN 3. TAO BANG INSPECTIONS
-- Lua chon quan he 1-N:
-- Mot hop dong co the co nhieu bien ban kiem tra trong qua trinh van hanh.
-- =========================================================

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,

    CONSTRAINT fk_inspections_rental
        FOREIGN KEY (rental_id)
        REFERENCES Rentals(rental_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================================
-- PHAN 4. TRIGGER BAO VE LOGIC NGHIEP VU
-- Khong cho lap bien ban khi hop dong van BOOKED hoac da CANCELLED.
-- =========================================================

DROP TRIGGER IF EXISTS trg_inspection_requires_active_rental;

DELIMITER //

CREATE TRIGGER trg_inspection_requires_active_rental
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    DECLARE rental_status VARCHAR(20);

    SET rental_status = (
        SELECT status
        FROM Rentals
        WHERE rental_id = NEW.rental_id
        LIMIT 1
    );

    IF rental_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Rental does not exist';
    END IF;

    IF rental_status NOT IN ('ACTIVE', 'COMPLETED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Inspection is allowed only for ACTIVE or COMPLETED rentals';
    END IF;
END//

DELIMITER ;

-- =========================================================
-- PHAN 5. DML MO PHONG NGHIEP VU
-- Nguyen Van A thue xe, coc 10.000.000 VND, sau do tra xe
-- va bi ghi nhan vo den pha trai, phi sua 2.000.000 VND.
-- =========================================================

INSERT INTO Cars (model_name, license_plate)
VALUES ('Toyota Vios 2025', '20A-123.45');

INSERT INTO Rentals (
    car_id,
    customer_name,
    rent_date,
    return_date,
    status,
    security_deposit,
    late_fee,
    damage_fee
)
VALUES (
    1,
    'Nguyen Van A',
    '2026-09-26 08:00:00',
    NULL,
    'ACTIVE',
    10000000.00,
    0.00,
    0.00
);

SET @rental_id = LAST_INSERT_ID();

INSERT INTO Inspections (
    rental_id,
    inspection_date,
    damage_description,
    inspector_name
)
VALUES (
    @rental_id,
    '2026-09-28 17:00:00',
    'Vo den pha trai',
    'Tran Van B'
);

UPDATE Rentals
SET
    return_date = '2026-09-28 17:00:00',
    status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = @rental_id;

-- =========================================================
-- PHAN 6. TRUY VAN KIEM TRA
-- Tien hoan = Tien coc - Phi tre - Phi hu hong
-- Ket qua mong doi: 8.000.000 VND
-- =========================================================

SELECT
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.status,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount
FROM Rentals r
JOIN Cars c ON c.car_id = r.car_id
WHERE r.rental_id = @rental_id;

-- Xem chi tiet bien ban kiem tra kem thong tin hop dong.
SELECT
    i.inspection_id,
    i.rental_id,
    r.customer_name,
    r.status,
    i.inspection_date,
    i.damage_description,
    i.inspector_name
FROM Inspections i
JOIN Rentals r ON r.rental_id = i.rental_id
WHERE i.rental_id = @rental_id;

-- Vi du test trigger (de comment de script chay tron ven):
-- INSERT INTO Rentals (
--     car_id, customer_name, rent_date, status, security_deposit
-- )
-- VALUES (1, 'Khach Test', '2026-10-01 08:00:00', 'BOOKED', 5000000.00);
--
-- SET @booked_rental_id = LAST_INSERT_ID();
--
-- INSERT INTO Inspections (
--     rental_id, damage_description, inspector_name
-- )
-- VALUES (
--     @booked_rental_id,
--     'Khong duoc phep ghi nhan o trang thai BOOKED',
--     'Tester'
-- );
-- Cau lenh INSERT Inspections tren phai bi trigger tu choi.
