# Git Basic Practice

Project thuc hanh Git.

## Bai tap SQL - QuanLyDiemThi

File bai lam: [sql/QuanLyDiemThi.sql](sql/QuanLyDiemThi.sql)

## Bai tap SQL - QuanLySinhVien

- [sql/QuanLySinhVien.sql](sql/QuanLySinhVien.sql)
- [sql/QuanLySinhVien_InsertData.sql](sql/QuanLySinhVien_InsertData.sql)
- [sql/QuanLySinhVien_SelectQuery.sql](sql/QuanLySinhVien_SelectQuery.sql)
- [sql/QuanLySinhVien_AdvancedQuery.sql](sql/QuanLySinhVien_AdvancedQuery.sql)

## Bai tap SQL - QuanLyBanHang

- [sql/QuanLyBanHang.sql](sql/QuanLyBanHang.sql)
- [sql/QuanLyBanHang_InsertAndQuery.sql](sql/QuanLyBanHang_InsertAndQuery.sql)

## Bai tap HealthSync

- [healthsync/healthsync_db.sql](healthsync/healthsync_db.sql)
- [healthsync/consistency_report.md](healthsync/consistency_report.md)
- [healthsync/ai_prompt_log.md](healthsync/ai_prompt_log.md)

## Bai tap AutoRide

- [autoride/autoride_db.sql](autoride/autoride_db.sql)
- [autoride/er_activity_mapping.md](autoride/er_activity_mapping.md)
- [autoride/ai_prompt_log.md](autoride/ai_prompt_log.md)

## Bai tap FlashMart - JOIN & Anti-Join

- [flashmart/flashmart_reports.sql](flashmart/flashmart_reports.sql)
- [flashmart/join_analysis.md](flashmart/join_analysis.md)
- [flashmart/ai_prompt_log.md](flashmart/ai_prompt_log.md)

## Bai tap PayFlow - EXPLAIN, Index & SARGable

File nop bai:

- [payflow/payflow_optimized.sql](payflow/payflow_optimized.sql) - Tao bang, du lieu mo phong, EXPLAIN, composite index va truy van SARGable.
- [payflow/explain_analysis.md](payflow/explain_analysis.md) - So sanh execution plan truoc va sau toi uu.
- [payflow/ai_prompt_log.md](payflow/ai_prompt_log.md) - Nhat ky cau hoi ky thuat ve Index, B-Tree, SARGable va EXPLAIN.

Diem chinh:

- Legacy query dung YEAR()/MONTH() tren created_at.
- Tao composite index idx_type_date(transaction_type, created_at).
- Refactor sang created_at >= '2026-06-01' AND created_at < '2026-07-01'.
- Muc tieu EXPLAIN: type tu ALL sang range/ref, key hien idx_type_date va rows giam manh.
- Co ghi chu ve EXPLAIN ANALYZE de xem actual time/rows tren MySQL 8.0.18+.

## Cach chay

Mo MySQL Workbench, chon file SQL can chay va thuc thi toan bo script.
