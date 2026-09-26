# AI Prompt Log - PayFlow

Ngày thực hiện: 2026-09-26

> Các prompt dưới đây dùng AI để tìm hiểu khái niệm Index, EXPLAIN và SARGable; không yêu cầu AI viết toàn bộ đáp án bài tập.

## Prompt 1 - EXPLAIN type

**Prompt**

Trong MySQL EXPLAIN, các giá trị `ALL`, `index`, `range`, `ref`, `const` trong cột `type` khác nhau như thế nào?

**Kết luận**

`ALL` thường là Full Table Scan. `index` quét toàn bộ index. `range` đọc một khoảng khóa. `ref` tìm theo giá trị khóa không duy nhất. `const` thường là tra cứu rất chọn lọc theo khóa duy nhất/primary key.

## Prompt 2 - SARGable

**Prompt**

Thuật ngữ SARGable trong SQL nghĩa là gì? Vì sao `WHERE YEAR(created_at)=2026` thường khó dùng B-Tree index trên `created_at`?

**Kết luận**

Điều kiện SARGable cho phép Optimizer biến predicate thành thao tác tìm kiếm/range trên index. Bọc hàm quanh cột làm MySQL phải tính hàm cho từng giá trị và không thể trực tiếp xác định khoảng khóa của B-Tree.

## Prompt 3 - Composite Index order

**Prompt**

Với điều kiện `transaction_type = 'DEPOSIT'` và một khoảng `created_at`, thứ tự `(transaction_type, created_at)` trong composite index có ý nghĩa gì?

**Kết luận**

Equality trên cột đầu giúp giới hạn nhanh nhóm giao dịch, sau đó cột ngày có thể dùng range trên phần khóa tiếp theo. Quy tắc leftmost-prefix khiến thứ tự cột có ảnh hưởng lớn đến khả năng sử dụng index.

## Prompt 4 - Index Seek vs Index Scan

**Prompt**

Sự khác biệt giữa Index Seek và Index Scan về lượng dữ liệu phải đọc là gì?

**Kết luận**

Seek/range lookup đi trực tiếp tới vùng khóa cần thiết, còn scan đọc phần lớn hoặc toàn bộ cấu trúc index. Khi truy vấn có tính chọn lọc cao, seek/range thường tiết kiệm I/O hơn.

## Prompt 5 - B-Tree

**Prompt**

B-Tree index trong MySQL hỗ trợ tốt cho điều kiện equality và range như thế nào?

**Kết luận**

Các khóa được tổ chức có thứ tự, cho phép tìm nhanh điểm bắt đầu và duyệt liên tiếp đến điểm kết thúc của một khoảng, thay vì kiểm tra mọi dòng trong bảng.

## Prompt 6 - Using index condition vs Using index

**Prompt**

Trong cột Extra của EXPLAIN, `Using index condition` khác gì `Using index`?

**Kết luận**

`Using index condition` thường liên quan Index Condition Pushdown: MySQL lọc thêm bằng điều kiện ngay trong quá trình đọc index trước khi lấy full row. `Using index` thường chỉ covering index, nghĩa là dữ liệu cần cho truy vấn đã nằm trong index và không cần đọc row từ bảng.

## Prompt 7 - Write cost of indexes

**Prompt**

Nếu bảng Transactions có INSERT/UPDATE/DELETE rất nhiều mỗi giây, tạo quá nhiều index gây rủi ro gì?

**Kết luận**

Mỗi thao tác ghi phải duy trì thêm các cây index, làm tăng CPU, I/O, dung lượng lưu trữ và chi phí khóa/latch nội bộ. Vì vậy chỉ nên tạo các index phục vụ workload thực tế.

## Prompt 8 - Actual execution time

**Prompt**

Trong MySQL 8, ngoài EXPLAIN ước lượng, có cách nào xem actual execution time và actual rows không?

**Kết luận**

MySQL 8.0.18+ hỗ trợ `EXPLAIN ANALYZE`, vừa thực thi truy vấn vừa trả về thông tin thời gian và số dòng thực tế. Đây là lựa chọn hiện đại hơn các cơ chế profiling cũ.
