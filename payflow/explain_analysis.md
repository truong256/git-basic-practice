# EXPLAIN Analysis - PayFlow

Truy vấn cũ dùng `YEAR(created_at)` và `MONTH(created_at)`, khiến điều kiện trên `created_at` trở thành Non-SARGable. Trước khi có secondary index, `EXPLAIN` dự kiến cho `type = ALL`, `possible_keys = NULL` và `rows` gần với tổng số dòng của bảng: MySQL phải quét toàn bộ dữ liệu.

Giải pháp tạo composite B-Tree index `idx_type_date(transaction_type, created_at)` và viết lại thời gian thành khoảng `created_at >= '2026-06-01'` và `created_at < '2026-07-01'`. Khi dữ liệu đủ lớn và có tính chọn lọc phù hợp, `EXPLAIN` dự kiến chuyển sang `type = range`, `key = idx_type_date` và `rows` giảm mạnh vì chỉ đọc vùng khóa thỏa điều kiện.

`rows` là ước lượng của Optimizer nên giá trị cụ thể có thể thay đổi theo kích thước bảng, phân bố dữ liệu và thống kê. Trên bảng rất nhỏ, MySQL vẫn có thể chọn Full Table Scan nếu chi phí thấp hơn dùng index.
