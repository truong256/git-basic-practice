# Git Basic Practice

Project thuc hanh Git.

## Bai tap SQL - QuanLyDiemThi

Bai tap tao co so du lieu `QuanLyDiemThi` bang cau lenh SQL, gom 4 bang:

- `HocSinh`
- `MonHoc`
- `BangDiem`
- `GiaoVien`

File bai lam: [sql/QuanLyDiemThi.sql](sql/QuanLyDiemThi.sql)

## Bai tap SQL - QuanLySinhVien

Bai tap tao co so du lieu `QuanLySinhVien` bang cau lenh SQL, gom 4 bang:

- `Class`
- `Student`
- `Subject`
- `Mark`

File bai lam: [sql/QuanLySinhVien.sql](sql/QuanLySinhVien.sql)

## Bai tap SQL - QuanLyBanHang

Bai tap tao co so du lieu `QuanLyBanHang` va 4 bang:

- `Customer`
- `Order`
- `Product`
- `OrderDetail`

Quan he:

- Mot `Customer` co the co nhieu `Order`.
- Mot `Order` co the co nhieu san pham.
- Mot `Product` co the xuat hien trong nhieu hoa don.
- `OrderDetail` la bang trung gian giua `Order` va `Product`, co khoa chinh kep `(oID, pID)`.

File bai lam: [sql/QuanLyBanHang.sql](sql/QuanLyBanHang.sql)

## Bai tap HealthSync - UML Activity Diagram & ERD Consistency

Bai thuc hanh phan tich do venh giua quy trinh nghiep vu va thiet ke CSDL, sau do tai cau truc schema MySQL de ho tro day du vong doi lich hen, tien coc, phi phat va don thuoc.

File nop bai:

- [healthsync/healthsync_db.sql](healthsync/healthsync_db.sql) - Schema toi uu, rang buoc, trigger va du lieu mo phong.
- [healthsync/consistency_report.md](healthsync/consistency_report.md) - Gap Analysis giua Activity Diagram va Legacy Database.
- [healthsync/ai_prompt_log.md](healthsync/ai_prompt_log.md) - Nhat ky prompt AI trong qua trinh thiet ke.

## Cach chay

Mo MySQL Workbench, chon file SQL can chay va thuc thi toan bo script.
