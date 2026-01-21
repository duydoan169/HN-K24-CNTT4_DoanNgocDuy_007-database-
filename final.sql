create database hospital;
use hospital;
-- drop database hospital;
create table patients (
	patient_id int primary key auto_increment,
    full_name varchar(255) not null,
    phone_number varchar(9) unique not null,
    gender enum("Male", "Female") not null,
    date_of_birth date not null
);

create table doctors (
	doctor_id int primary key auto_increment,
    full_name varchar(255) not null,
    specialty varchar(255) not null,
    phone_number varchar(9) not null unique,
    rating decimal(2,1) default 5.0 check(rating >= 0.0 and rating <=5.0)
);

create table appointments (
	appointment_id int auto_increment primary key,
    patient_id int not null,
    doctor_id int not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id),
    appointment_time datetime not null,
    fee int check(fee >= 0),
    status enum("Booked", "Completed", "Cancelled")
);

create table medical_records (
	record_id int primary key auto_increment,
    appointment_id int not null,
    foreign key (appointment_id) references appointments(appointment_id),
    symptoms varchar(255) not null,
    diagnosis varchar(255) not null, 
    prescription varchar(255) not null,
    record_date datetime not null
);

create table visit_log (
	log_id int primary key auto_increment,
    record_id int not null,
    doctor_id int not null,
    foreign key (record_id) references medical_records(record_id),
    foreign key (doctor_id) references doctors(doctor_id),
    log_time datetime not null,
    note text
);

insert into patients values
(1, "Nguyen Thi Lan", "901234567", "Female", '1999-03-12'),
(2, "Tran Van Minh", "902345678", "Male", '1996-11-25'),
(3, "Le Hoai Phuong", "913456789", "Female", '2001-07-08'),
(4, "Pham Duc Anh", "984567890", "Male", '1998-01-19'),
(5, "Hoang Ngoc Mai", "975678901", "Female", '2000-09-30');

insert into doctors values
(1, "BS. Nguyen Van Hai", "Noi", "931112223", 4.8),
(2, "BS. Tran Thu Ha", "Nhi", "932223334", 5.0),
(3, "BS. Le Quoc Tuan", "Ngoai", "933334445", 4.6),
(4, "BS. Pham Minh Chau", "Da lieu", "934445556", 4.9),
(5, "BS. Hoang Gia Bao", "Tim mach", "935556667", 4.7);

insert into appointments values
(7001, 1, 1, '2024-05-20 08:00:00', 200000, "Booked"),
(7002, 2, 2, '2024-05-20 09:30:00', 250000, "Completed"),
(7003, 3, 3, '2024-05-20 10:15:00', 300000, "Booked"),
(7004, 4, 5, '2024-05-21 07:00:00', 350000, "Completed"),
(7005, 5, 4, '2024-05-21 08:45:00', 220000, "Cancelled");

insert into medical_records values
(8001, 7002, "Sốt cao, ho", "Viêm họng", "Paracetamol + siro ho", '2024-05-20 10:00:00'),
(8002, 7004, "Đau ngực nhẹ", "Theo dõi tim mạch", "Vitamin + tái khám", '2024-05-21 08:00:00'),
(8003, 7001, "Đau bụng", "Rối loạn tiêu hóa", "Men tiêu hóa", '2024-05-20 09:00:00'),
(8004, 7003, "Đau vai gáy", "Căng cơ", "Giảm đau + nghỉ ngơi", '2024-05-20 11:00:00'),
(8005, 7005, "Ngứa da", "Dị ứng", "Thuốc bôi ngoài da", '2024-05-21 09:00:00');

insert into visit_log values
(1, 8003, 1, '2024-05-20 09:05:00', "Đã khám lần đầu"),
(2, 8001, 2, '2024-05-20 10:05:00', "Đã khám lần đầu"),
(3, 8004, 3, '2024-05-20 11:10:00', "Đã khám lần đầu"),
(4, 8005, 5, '2024-05-21 09:05:00', "Đã khám lần đầu"),
(5, 8002, 4, '2024-05-21 08:10:00', "Đã khám lần đầu");

  -- Câu 2 – UPDATE & DELETE (10 điểm)
update appointments a
join patients p on p.patient_id = a.patient_id
set a.fee = a.fee * 1.1
where a.status = "Completed" and year(p.date_of_birth) < 2000;

delete from visit_log 
where log_time < '2024-05-20';

--    Câu 1 (5 điểm): Liệt kê các thông tin bác sĩ gồm full_name, specialty và rating của những bác sĩ có rating lớn hơn 4.7 hoặc thuộc chuyên khoa “Nhi”.
select full_name, specialty, rating from doctors
where specialty = "Nhi" or rating > 4.7;

-- Câu 2 (5 điểm): Liệt kê các thông tin bệnh nhân gồm full_name và phone_number của những bệnh nhân có ngày sinh 
-- trong khoảng từ 1998-01-01 đến 2001-12-31 và số điện thoại bắt đầu bằng “090”.

select full_name, phone_number from patients
where date_of_birth between '1998-01-01' and '2001-12-31'
and phone_number like '090%';

-- Câu 3 (5 điểm): Liệt kê các phiếu hẹn gồm appointment_id, appointment_time và fee, trong đó danh sách được sắp xếp theo 
-- fee giảm dần và chỉ hiển thị 2 phiếu ở trang thứ hai.

select appointment_id, appointment_time, fee from appointments
order by fee desc limit 2 offset 2;

-- PHẦN 4: TRUY VẤN NÂNG CAO (15 ĐIỂM)
-- Câu 1 (5 điểm): Liệt kê các thông tin khám gồm họ tên bệnh nhân, họ tên bác sĩ, chuyên khoa, phí khám và thời điểm hẹn khám
-- với dữ liệu được lấy từ các bảng liên quan trong hệ thống.

select p.full_name, d.full_name, d.specialty, a.fee, a.appointment_time
from appointments a join patients p on p.patient_id = a.patient_id
join doctors d on d.doctor_id = a.doctor_id;

-- Câu 2 (5 điểm): Liệt kê các thông tin bác sĩ gồm họ tên bác sĩ và tổng phí khám mà bác sĩ đó đã thực hiện (chỉ tính phiếu Completed)
-- chỉ hiển thị những bác sĩ có tổng phí lớn hơn 500.000.

select d.full_name, sum(a.fee) as total from doctors d
join appointments a on a.doctor_id = d.doctor_id
where a.status = "Completed"
group by d.doctor_id having sum(a.fee) > 500000;

-- Câu 3 (5 điểm): Liệt kê các thông tin bác sĩ gồm doctor_id, full_name và rating của những bác sĩ có điểm đánh giá cao nhất

select d.doctor_id, d.full_name, d.rating from doctors d
where d.rating = (select max(d2.rating) from doctors d2);

-- PHẦN 5: INDEX & VIEW (10 ĐIỂM)
-- Câu 1 (5 điểm): Tạo một chỉ mục trên bảng appointments dựa trên hai thông tin là trạng thái
--  hẹn khám và phí khám nhằm phục vụ việc tối ưu truy vấn.

create index idx_c_status_fee on appointments(status, fee);

-- Câu 2 (5 điểm): Tạo một khung nhìn dữ liệu hiển thị họ tên bác sĩ, tổng số phiếu hẹn mà bác sĩ đã nhận
-- và tổng doanh thu phí khám mà bác sĩ đó mang lại, trong đó không tính các phiếu bị hủy.

create view v_total_appointments as
select d.full_name, count(a.appointment_id) as total_appointments, sum(a.fee) as total_fee
from appointments a join doctors d on d.doctor_id = a.doctor_id
where a.status <> "Cancelled"
group by d.doctor_id;

select * from v_total_appointments;

-- PHẦN 6: TRIGGER (10 ĐIỂM)

--   Câu 1 (5 điểm): Viết một trigger sao cho khi trạng thái của một phiếu hẹn trong bảng appointments được 
-- cập nhật sang giá trị Completed thì hệ thống tự động thêm một bản ghi mới vào bảng visit_log với các thông tin sau:
-- -  appointment_id/record_id: hồ sơ tương ứng của phiếu vừa cập nhật
-- -  doctor_id: bác sĩ của phiếu hẹn
-- -  note: Visit completed
-- -  log_time: thời gian hiện tại của hệ thống

delimiter $$
create trigger tr_after_update_appointment 
after update on appointments
for each row
begin
	insert into visit_log(record_id, doctor_id, note, log_time) values
    (old.appointment_id, old.doctor_id, "Visit completed", now());
end $$
delimiter ;

--   Câu 2 (5 điểm): Viết một trigger sao cho khi thêm mới một bản ghi vào bảng appointments có trạng thái
-- Completed thì hệ thống tự động tăng điểm đánh giá của bác sĩ tương ứng trong bảng doctors thêm 0.1,
--  đảm bảo điểm đánh giá không vượt quá 5.0.

delimiter $$
create trigger tr_after_insert_appointment 
after insert on appointments
for each row
begin
	if(new.status = "Completed" and (select rating from doctors where doctor_id = new.doctor_id) <= 4.9) then
		update doctors set rating = rating + 0.1 where doctor_id = new.doctor_id;
	end if;
end $$
delimiter ;

-- PHẦN 7: STORED PROCEDURE (15 ĐIỂM)

--   Câu 1 (5 điểm): Viết một stored procedure nhận vào mã bác sĩ và trả về một thông báo kết quả, trong đó:
--    -  Nếu tổng phí khám Completed của bác sĩ > 1,000,000 thì trả về High revenue.
--    -  Nếu bằng nhau thì trả về Target met.
--    -  Nếu nhỏ hơn thì trả về Normal.

delimiter $$

create procedure sp_notif(
	in p_doctor_id int,
    out p_notif varchar(50)
)
begin
	declare total_fee int;

	select sum(fee)
	into total_fee
	from appointments
	where doctor_id = p_doctor_id and status = "Completed";

	if total_fee > 1000000 then
		set p_notif = "High revenue";
	elseif total_fee = 1000000 then
		set p_notif = "Target met";
	else
		set p_notif = "Normal";
	end if;
end $$

delimiter ;
