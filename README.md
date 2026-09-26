# Git Basic Practice

Project thuc hanh Git.

## Bai tap SQL - QuanLyDiemThi

File bai lam: [sql/QuanLyDiemThi.sql](sql/QuanLyDiemThi.sql)

## Bai tap SQL - QuanLySinhVien

File bai lam: [sql/QuanLySinhVien.sql](sql/QuanLySinhVien.sql)

## Bai tap SQL - QuanLyBanHang

File bai lam: [sql/QuanLyBanHang.sql](sql/QuanLyBanHang.sql)

## Bai tap HealthSync - UML Activity Diagram & ERD Consistency

File nop bai:

- [healthsync/healthsync_db.sql](healthsync/healthsync_db.sql)
- [healthsync/consistency_report.md](healthsync/consistency_report.md)
- [healthsync/ai_prompt_log.md](healthsync/ai_prompt_log.md)

## Bai tap AutoRide - Activity Diagram & Database Integrity

Bai thuc hanh phan tich cac Data Gap giua quy trinh thue/tra xe va Legacy Database, sau do nang cap schema MySQL bang ALTER TABLE.

File nop bai:

- [autoride/autoride_db.sql](autoride/autoride_db.sql) - DDL, ALTER TABLE, constraints, trigger va DML mo phong.
- [autoride/er_activity_mapping.md](autoride/er_activity_mapping.md) - Phan tich ngan ve Data Gap va vai tro cua damage_fee.
- [autoride/ai_prompt_log.md](autoride/ai_prompt_log.md) - Nhat ky cac cau hoi ky thuat da trao doi voi AI.

Diem noi bat:

- Doi status tu VARCHAR sang ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED').
- Them security_deposit, late_fee, damage_fee bang DECIMAL(10,2).
- Them CHECK de ngan gia tri am va ngan tong phi vuot tien coc.
- Tao bang Inspections va khoa ngoai ON DELETE RESTRICT.
- Dung trigger chan insert bien ban kiem tra khi hop dong dang BOOKED/CANCELLED.
- Mo phong Nguyen Van A coc 10.000.000 VND, hu hong 2.000.000 VND.
- SELECT tinh tien hoan mong doi 8.000.000 VND.

## Cach chay

Mo MySQL Workbench, chon file SQL can chay va thuc thi toan bo script.
