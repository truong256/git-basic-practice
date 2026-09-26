# AI Prompt Log - FlashMart

Ngày thực hiện: 2026-09-26

> Nhật ký tập trung vào câu hỏi lý thuyết và tối ưu JOIN, không yêu cầu AI tạo toàn bộ đáp án bài tập.

## Prompt 1 - JOIN mặc định trong MySQL

**Prompt**

Trong MySQL, nếu chỉ viết `JOIN` mà không ghi `LEFT` hoặc `RIGHT`, nó hoạt động như loại JOIN nào? Các dòng không có bản ghi khớp sẽ được xử lý ra sao?

**Kết luận**

`JOIN` mặc định là `INNER JOIN`. Chỉ các dòng có điều kiện nối khớp ở cả hai bảng mới được giữ lại; bản ghi không khớp sẽ bị loại.

## Prompt 2 - LEFT JOIN theo lý thuyết tập hợp

**Prompt**

Hãy giải thích sự khác biệt giữa `INNER JOIN` và `LEFT JOIN` bằng tư duy tập hợp/Venn Diagram.

**Kết luận**

`INNER JOIN` lấy phần giao nhau giữa hai tập dữ liệu. `LEFT JOIN` giữ toàn bộ tập bên trái, đồng thời ghép dữ liệu bên phải nếu có; nếu không khớp thì các cột bên phải là `NULL`.

## Prompt 3 - COUNT(*) và COUNT(column)

**Prompt**

Khi dùng `LEFT JOIN` để đếm đơn hàng của từng khách, khác biệt giữa `COUNT(*)` và `COUNT(o.order_id)` là gì?

**Kết luận**

`COUNT(*)` đếm mọi dòng kết quả, kể cả dòng do LEFT JOIN tạo ra khi bên phải là NULL. `COUNT(o.order_id)` bỏ qua NULL nên khách chưa mua hàng có số đơn bằng 0.

## Prompt 4 - Anti-Join

**Prompt**

Vì sao mẫu `LEFT JOIN ... WHERE right_table.id IS NULL` có thể dùng để tìm các bản ghi chưa từng xuất hiện ở bảng giao dịch?

**Kết luận**

LEFT JOIN giữ toàn bộ bảng gốc. Những dòng không có bản ghi tham chiếu sẽ có các cột bên phải bằng NULL; lọc khóa chính bên phải IS NULL sẽ giữ đúng các bản ghi không có quan hệ tương ứng.

## Prompt 5 - LEFT JOIN IS NULL và NOT IN

**Prompt**

Khi tìm dữ liệu không tồn tại ở bảng khác, `LEFT JOIN ... IS NULL` khác gì `NOT IN` về tính đúng đắn và hiệu năng trong MySQL?

**Kết luận**

`NOT IN` có thể gây kết quả bất ngờ nếu subquery chứa NULL. `LEFT JOIN ... IS NULL` hoặc `NOT EXISTS` thường rõ nghĩa hơn cho Anti-Join. Hiệu năng thực tế phụ thuộc index và MySQL Optimizer.

## Prompt 6 - Nested-Loop Join

**Prompt**

MySQL Optimizer thường thực hiện JOIN bằng Nested-Loop Join như thế nào và index trên khóa nối giúp gì?

**Kết luận**

MySQL có thể lấy từng dòng từ bảng dẫn động rồi tìm bản ghi khớp ở bảng còn lại. Index trên các cột như `Orders.customer_id` và `Orders.product_id` giúp giảm số dòng phải quét và tăng tốc phép nối.

## Prompt 7 - FULL OUTER JOIN

**Prompt**

MySQL không có cú pháp FULL OUTER JOIN trực tiếp. Có thể mô phỏng bằng cách kết hợp LEFT JOIN và RIGHT JOIN như thế nào?

**Kết luận**

Có thể kết hợp kết quả `LEFT JOIN` và `RIGHT JOIN` bằng `UNION`, đồng thời xử lý trùng lặp phù hợp. Cách này chỉ nên dùng khi thực sự cần giữ dữ liệu không khớp từ cả hai phía.
