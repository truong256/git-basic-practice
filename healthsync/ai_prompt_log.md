# AI Prompt Log - HealthSync

Ngày thực hiện: 2026-09-26

> Nhật ký này ghi lại các câu hỏi kỹ thuật dùng AI như một trợ lý mô hình hóa dữ liệu. Các prompt tập trung vào khái niệm/cú pháp và không yêu cầu AI viết toàn bộ bài từ đầu.

## Prompt 1 - Lifecycle status

**Prompt**

Trong thiết kế cơ sở dữ liệu quan hệ, tại sao việc dùng một cột `is_active` kiểu BOOLEAN/TINYINT để theo dõi vòng đời của một lịch hẹn lại là anti-pattern? Nên thay bằng cấu trúc nào?

**Kết luận sử dụng**

Boolean chỉ biểu diễn hai trạng thái nên làm mất thông tin về các bước trung gian. Với HealthSync, dùng `ENUM('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED')` giúp trạng thái rõ ràng và giới hạn dữ liệu hợp lệ.

## Prompt 2 - Kiểu dữ liệu tiền tệ

**Prompt**

Khi thiết kế `deposit_amount` và `penalty_fee` trong MySQL để tính toán tài chính, nên dùng FLOAT, DOUBLE hay DECIMAL? Tại sao?

**Kết luận sử dụng**

Chọn `DECIMAL(12,2)` vì DECIMAL lưu số thập phân theo dạng chính xác, phù hợp tiền tệ. FLOAT/DOUBLE là số dấu phẩy động xấp xỉ nên có thể phát sinh sai số khi cộng, trừ hoặc đối soát nhiều giao dịch.

## Prompt 3 - ALTER TABLE và ENUM

**Prompt**

Cú pháp MySQL để bỏ cột `is_active` và thêm cột `status` dạng ENUM gồm PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED vào bảng hiện có là gì?

**Kết luận sử dụng**

Có thể dùng `ALTER TABLE ... DROP COLUMN ...` và `ALTER TABLE ... ADD COLUMN ...`. Trong bài thực hành chọn tái tạo bảng để schema dễ chạy lại và kiểm thử độc lập.

## Prompt 4 - Foreign key và ON DELETE

**Prompt**

Khi bảng `Prescriptions` tham chiếu `Appointments`, nên dùng `ON DELETE CASCADE` hay `ON DELETE RESTRICT` nếu cần bảo toàn hồ sơ khám bệnh?

**Kết luận sử dụng**

Chọn `ON DELETE RESTRICT` để tránh việc xóa lịch hẹn làm mất đơn thuốc/hồ sơ đã phát sinh. Nếu hệ thống có yêu cầu xóa dây chuyền dữ liệu thử nghiệm thì CASCADE mới phù hợp hơn.

## Prompt 5 - Bảo vệ logic bằng Trigger

**Prompt**

Làm thế nào để chặn INSERT vào `Prescriptions` khi lịch hẹn tương ứng chưa ở trạng thái `COMPLETED`?

**Kết luận sử dụng**

Dùng `BEFORE INSERT TRIGGER`, đọc `Appointments.status`; nếu khác `COMPLETED` thì dùng `SIGNAL SQLSTATE '45000'` để từ chối thao tác. Điều này bảo vệ logic ngay ở tầng cơ sở dữ liệu, không phụ thuộc hoàn toàn vào Backend.
