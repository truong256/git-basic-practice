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

### Cach chay

Mo MySQL Workbench, mo file `sql/QuanLyDiemThi.sql` va chay toan bo script.
