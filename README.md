# Git Basic Practice

Project thuc hanh Git.

## Bai tap SQL - QuanLyDiemThi

Bai tap tao co so du lieu `QuanLyDiemThi` bang cau lenh SQL, gom 4 bang:

- `HocSinh`
- `MonHoc`
- `BangDiem`
- `GiaoVien`

Bai lam co day du:

- Khoa chinh cho cac bang.
- Khoa chinh kep `(MaHS, MaMH)` cho bang `BangDiem`.
- Khoa ngoai `BangDiem.MaHS -> HocSinh.MaHS`.
- Khoa ngoai `BangDiem.MaMH -> MonHoc.MaMH`.
- Khoa ngoai `MonHoc.MaGV -> GiaoVien.MaGV`.

File bai lam: [sql/QuanLyDiemThi.sql](sql/QuanLyDiemThi.sql)

## Bai tap SQL - QuanLySinhVien

Bai tap tao co so du lieu `QuanLySinhVien` bang cau lenh SQL, gom 4 bang:

- `Class`
- `Student`
- `Subject`
- `Mark`

Bai lam co day du:

- `PRIMARY KEY` va `AUTO_INCREMENT`.
- Rang buoc `NOT NULL`.
- Gia tri mac dinh bang `DEFAULT`.
- Rang buoc `CHECK` cho `Credit >= 1`.
- Rang buoc `CHECK` cho `Mark BETWEEN 0 AND 100`.
- Rang buoc `UNIQUE (SubID, StudentID)`.
- Khoa ngoai `Student.ClassID -> Class.ClassID`.
- Khoa ngoai `Mark.SubID -> Subject.SubID`.
- Khoa ngoai `Mark.StudentID -> Student.StudentID`.

File bai lam: [sql/QuanLySinhVien.sql](sql/QuanLySinhVien.sql)

## Cach chay

Mo MySQL Workbench, chon file SQL can chay trong thu muc `sql`, sau do chay toan bo script.
