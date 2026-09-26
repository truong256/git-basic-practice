# Consistency Report - HealthSync

## Gap Analysis giữa Activity Diagram và Legacy Database

Thiết kế cũ của HealthSync có nhiều điểm không nhất quán với quy trình nghiệp vụ. Thứ nhất, cột `is_active` kiểu Boolean chỉ biểu diễn được hai trạng thái, trong khi một lịch hẹn thực tế phải đi qua năm trạng thái `PENDING`, `CONFIRMED`, `CHECKED_IN`, `COMPLETED` và `CANCELLED`. Vì vậy hệ thống không thể biết chính xác lịch hẹn đang ở bước nào của vòng đời.

Thứ hai, bảng `Appointments` không có `deposit_amount` và `penalty_fee`. Điều này làm mất dữ liệu tài chính quan trọng, khiến hệ thống không thể ghi nhận tiền cọc, phí phạt khi hủy và số tiền còn lại cần hoàn cho bệnh nhân. Kế toán cũng không thể đối soát doanh thu chính xác.

Thứ ba, thiết kế cũ thiếu `cancel_reason`, nên khi bệnh nhân hủy lịch sau khi đã xác nhận, cơ sở dữ liệu không lưu được nguyên nhân hủy để phục vụ kiểm tra nghiệp vụ hoặc chăm sóc khách hàng.

Thứ tư, hoàn toàn không có bảng `Prescriptions`. Do đó bác sĩ không có nơi lưu đơn thuốc sau khi lịch hẹn chuyển sang `COMPLETED`. Thiết kế mới bổ sung bảng này và liên kết bằng khóa ngoại với `Appointments`.

Ngoài việc bổ sung dữ liệu còn thiếu, thiết kế mới dùng `DECIMAL` cho các giá trị tiền tệ và thêm ràng buộc/trigger để giảm khả năng lưu dữ liệu phi logic.
