# Join Analysis - FlashMart

Trong báo cáo Marketing phải dùng `COUNT(o.order_id)` thay vì `COUNT(*)`. Với `LEFT JOIN`, mỗi khách hàng bên trái luôn tạo ít nhất một dòng kết quả. Nếu khách chưa có đơn hàng, các cột của `Orders` sẽ là `NULL`. `COUNT(*)` vẫn đếm dòng đó nên Charlie có thể bị tính sai thành 1 đơn. Ngược lại, `COUNT(o.order_id)` chỉ đếm các giá trị `order_id` không NULL; vì vậy khách hàng chưa từng mua hàng nhận đúng kết quả 0.

Cùng nguyên tắc đó, bài toán tìm sản phẩm chưa bán dùng `Products LEFT JOIN Orders`, rồi lọc `WHERE o.order_id IS NULL`. Đây là kỹ thuật Anti-Join: giữ toàn bộ sản phẩm trước, sau đó chỉ lấy các sản phẩm không tìm thấy bản ghi giao dịch tương ứng.
