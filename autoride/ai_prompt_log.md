# AI Prompt Log - AutoRide

Ngày thực hiện: 2026-09-26

> Các câu hỏi dưới đây tập trung vào khái niệm và cú pháp kỹ thuật, dùng AI như một trợ lý thiết kế thay vì yêu cầu tạo toàn bộ bài từ đầu.

## Prompt 1 - DECIMAL cho dữ liệu tài chính

**Prompt**

Trong MySQL, vì sao các cột `security_deposit`, `late_fee` và `damage_fee` nên dùng `DECIMAL(10,2)` thay vì FLOAT hoặc DOUBLE?

**Kết luận sử dụng**

`DECIMAL` lưu giá trị thập phân chính xác, phù hợp với tiền tệ. FLOAT/DOUBLE là kiểu xấp xỉ nên có thể tạo sai số khi cộng, trừ hoặc đối soát nhiều giao dịch.

## Prompt 2 - ENUM cho trạng thái hợp đồng

**Prompt**

Khi một hợp đồng thuê xe chỉ được phép có các trạng thái BOOKED, ACTIVE, COMPLETED và CANCELLED, dùng ENUM có ưu điểm gì so với VARCHAR?

**Kết luận sử dụng**

`ENUM` giới hạn giá trị đầu vào vào một tập trạng thái xác định, giúp tránh dữ liệu như `DONE`, `Finish` hoặc lỗi chính tả làm sai luồng nghiệp vụ.

## Prompt 3 - Quan hệ 1-1 hay 1-N cho Inspections

**Prompt**

Bảng biên bản kiểm tra xe nên có quan hệ 1-1 hay 1-N với Rentals nếu hệ thống có thể kiểm tra xe nhiều lần trong một hợp đồng?

**Kết luận sử dụng**

Chọn 1-N để hỗ trợ nhiều lần kiểm tra như lúc nhận xe, lúc trả xe hoặc kiểm tra bổ sung. Mỗi bản ghi `Inspections` giữ một `rental_id` làm khóa ngoại.

## Prompt 4 - ON DELETE RESTRICT

**Prompt**

Khi `Inspections` tham chiếu `Rentals`, `ON DELETE RESTRICT` giúp bảo vệ dữ liệu như thế nào?

**Kết luận sử dụng**

RESTRICT ngăn xóa một hợp đồng nếu đã có biên bản kiểm tra liên quan, qua đó tránh mất bằng chứng vận hành và dữ liệu phục vụ đối soát.

## Prompt 5 - NULL và phép tính hoàn tiền

**Prompt**

Trong MySQL, nếu `late_fee` hoặc `damage_fee` là NULL thì phép tính tiền hoàn có vấn đề gì? Nên xử lý ra sao?

**Kết luận sử dụng**

Bất kỳ phép toán nào chứa NULL thường trả về NULL. Vì vậy thiết kế dùng `NOT NULL DEFAULT 0.00` cho các cột phí. Khi làm việc với dữ liệu cũ vẫn có thể dùng `COALESCE(column, 0)`.

## Prompt 6 - Trigger kiểm soát trạng thái

**Prompt**

Làm thế nào để chặn INSERT vào bảng `Inspections` khi hợp đồng thuê xe vẫn ở trạng thái `BOOKED`?

**Kết luận sử dụng**

Có thể dùng `BEFORE INSERT TRIGGER` để đọc `Rentals.status`. Nếu trạng thái không phải `ACTIVE` hoặc `COMPLETED`, dùng `SIGNAL SQLSTATE '45000'` để từ chối thao tác.
