# ER - Activity Mapping: AutoRide

Thiết kế legacy không thể phản ánh đầy đủ Activity Diagram vì ba khoảng trống dữ liệu chính. Thứ nhất, `status` dạng `VARCHAR` cho phép nhập trạng thái tùy ý, làm mất tính nhất quán của vòng đời `BOOKED -> ACTIVE -> COMPLETED/CANCELLED`. Thứ hai, hệ thống thiếu `security_deposit`, `late_fee` và đặc biệt là `damage_fee`, nên kế toán không thể xác định chính xác số tiền phải hoàn sau khi khách trả xe.

`damage_fee` là bắt buộc vì hư hỏng là một nhánh nghiệp vụ độc lập trong Activity Diagram. Nếu chỉ ghi mô tả hư hỏng mà không lưu giá trị bồi thường, dữ liệu tài chính sẽ không thể đối soát và hệ thống có thể hoàn lại toàn bộ tiền cọc dù xe bị thiệt hại. Vì vậy `damage_fee` được lưu bằng `DECIMAL(10,2)`, tránh sai số của số dấu phẩy động.

Ngoài ra, bảng `Inspections` được tách riêng để một hợp đồng có thể lưu nhiều lần kiểm tra và nhiều thông tin nghiệp vụ mà không làm bảng `Rentals` phình to. Khóa ngoại `rental_id` với `ON DELETE RESTRICT` giúp bảo toàn lịch sử kiểm tra xe.
