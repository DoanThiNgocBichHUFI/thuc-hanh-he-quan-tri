-- bai1: viết lệnh cài đặt csdl

create database QLDH_zech on primary 
(
	name = QLDH_primary, 
	filename= 'C:\TH_HQT\buoi 1\QLDH_primary.mdf',
	size= 3MB,
	maxsize= 10MB,
	filegrowth= 10%
)
log on
(
name= QLDH_log,
filename= 'C:\TH_HQT\buoi 1\QLDH_log.ldf',
size= 1MB,
maxsize = 5MB,
filegrowth= 10%
)

-- bài 2. tạo các bảng
use QLDH_zech
go
create table HangHoa
(
MaHH char(2),
TenHH nvarchar(20),
DVT nvarchar(10),
SLCon smallint,
DonGiaHH int,
Constraint pk_HH Primary Key(MaHH)
)
go

create table KhachHang
(
MaKH char(10),
TenKH nvarchar(50),
DienThoai char (12),
constraint pk_KhachHang	Primary key(MaKH)
)
go

create table DonDatHang
(
MaDat char(4),
NgayDat smalldatetime, 
MaKH char(10),
TinhTrang bit,
constraint pk_DDH Primary key (MaDat),
constraint fk_DDH_KH Foreign key(MaKH) references KhachHang(MaKH)
)
go

create table ChiTietDatHang
(
MaDat char(4),
MaHH char(2),
SLDat smallint,
constraint pk_CTDH primary key (MaDat,MaHH),
constraint fk_CTDH foreign key (MaHH) references HangHoa(MaHH)
)

alter table ChiTietDatHang 
add constraint fk_CTDH foreign key(MaDat) references DonDatHang(MaDat)
select *from HangHoa

alter table HangHoa
add constraint uni_TenHH Unique(TenHH)

alter table HangHoa
add constraint chk_SLC check(SLCon >=0)

insert into HangHoa values('H1','hang 1','ki',-1,null)
insert into HangHoa values('H1','hang 1','ki',11,null)

CREATE TABLE PhieuGiaoHang
(
    MaGiao CHAR(10),
    NgayGiao SMALLDATETIME,
    SLGiao SMALLINT,
    DonGiaGiao INT,
    CONSTRAINT pk_PhieuGiaoHang PRIMARY KEY (MaGiao)
);

-- Dữ liệu cho bảng HangHoa
INSERT INTO HangHoa(MaHH, TenHH, DVT, SLCon, DonGiaHH)
VALUES 
('01', 'Hàng hóa 1', 'Cái', 100, 50000),
('02', 'Hàng hóa 2', 'Cái', 200, 60000),
('03', 'Hàng hóa 3', 'Cái', 300, 70000),
('04', 'Hàng hóa 4', 'Cái', 400, 80000),
('05', 'Hàng hóa 5', 'Cái', 500, 90000);

-- Dữ liệu cho bảng KhachHang
INSERT INTO KhachHang(MaKH, TenKH, DienThoai)
VALUES 
('KH0001', 'Khách hàng 1', '0123456789'),
('KH0002', 'Khách hàng 2', '0123456780'),
('KH0003', 'Khách hàng 3', '0123456709'),
('KH0004', 'Khách hàng 4', '0123456079'),
('KH0005', 'Khách hàng 5', '0123450798');

-- Dữ liệu cho bảng DonDatHang
INSERT INTO DonDatHang(MaDat, NgayDat, MaKH, TinhTrang)
VALUES 
('DDH1', '2023-12-12', 'KH0001', 1),
('DDH2', '2023-12-13', 'KH0002', 0),
('DDH3', '2023-12-14', 'KH0003', 1),
('DDH4', '2023-12-15', 'KH0004', 0),
('DDH5', '2023-12-16', 'KH0005', 1);

-- Dữ liệu cho bảng ChiTietDatHang
INSERT INTO ChiTietDatHang(MaDat, MaHH, SLDat)
VALUES 
('DDH1', '01', 10),
('DDH2', '02', 20),
('DDH3', '03', 30),
('DDH4', '04', 40),
('DDH5', '05', 50);

--1. Cho biết chi tiết giao hàng của đơn đặt hàng DH01, hiển thị: tên hàng hóa, số lượng
--giao và đơn giá giao.

--2. Cho biết thông tin những đơn đặt hàng không được giao, hiển thị: mã đặt, ngày đặt,
--tên khách hàng.

select MaDat,NgayDat,TenKH from DonDatHang ddh join KhachHang kh on ddh.MaKH= kh.MaKH where TinhTrang= 0


--3. Cho biết hàng hóa nào có đơn giá hiện hành cao nhất, hiển thị: tên hàng hóa, đơn
--giá hiện hành.
select TenHH,DonGiaHH from HangHoa where DonGiaHH= ( select max(DonGiaHH) from HangHoa)

--4. Cho biết số lần đặt hàng của từng khách hàng, những khách hàng không đặt hàng phải hiện null

select kh.MaKH,count(ddh.MaDat) as N'Số lần ĐH' from KhachHang kh
left join DonDatHang ddh on kh.MaKH= ddh.MaKH
group by kh.MaKH

insert into KhachHang values('KH0006','Khách hàng 6',null)

--5. Cho biết tổng tiền của từng phiếu giao hàng trong năm 2012, hiển thị: mã giao, ngày
--giao, tổng tiền, với tổng tiền =SUM(SLGiao * DonGiaGiao)

select sum(SLDat *DonGiaHH) as N'Tổng tiền' from DonDatHang ddh join ChiTietDatHang ct on ddh.MaDat= ct.MaDat
join HangHoa hh on hh.MaHH= ct.MaHH where year(NgayDat)= 2023

--6. Cho biết khách hàng nào có 2 lần đặt hàng trở lên, hiển thị: mã khách hàng, tên
--khách hàng, số lần đặt.
select ddh.MaKH, TenKH, count(ddh.MaDat) as N'số lần đặt' from DonDatHang ddh join KhachHang kh on ddh.MaKH= kh.MaKH group by ddh.MaKH, TenKH having count(ddh.MaDat)>= 2
--7. Cho biết mặt hàng nào đã được giao với tổng số lượng giao nhiều nhất, hiển thị: mã
--hàng, tên hàng hóa, tổng số lượng đã giao.
select MaHH, TenHH, SUM(MaDat) from  DonDatHang ddh on ct.MaDat= ddh.MaDat where ct.SLDat= (select max(SLDat) from ChiTietDatHang )
select max(SLDat) from ChiTietDatHang ct join DonDatHang ddh on ct.MaDat= ddh.MaDat where TinhTrang= 1

--8. Tăng số lượng còn của mặt hàng có mã bắt đầu là M lên 10.
update HangHoa set SLCon= SLCon+10 where MaHH like 'M%'
 --Tăng số lượng còn của mặt hàng có mã có chứa kí tự là M lên 10.
update HangHoa set SLCon= SLCon +10 where MaHH like '%M%'
--9. Thêm cột ThanhTien cho bảng ChiTietGiaoHang, sau đó cập nhật giá trị cho cột
--này với ThanhTien =SLGiao * DonGiaGiao
-- Thêm cột ThanhTien vào bảng ChiTietGiaoHang
alter table ChiTietGiaoHang 
add ThanhTien float;
update ChiTietDatHang set ThanhTien= SLGiao * DonGiaGiao;

select *from ChiTietDatHang
select *from DonDatHang
select *from KhachHang
select *from HangHoa

--bài 2
CREATE DATABASE DB_QLTHUVIEN
ON PRIMARY 
(NAME = 'DB_PRIMARY', FILENAME = 'C:\\SQLData\\db_primary.mdf', SIZE = 3MB, MAXSIZE = 10MB, FILEGROWTH = 10%),
FILEGROUP DB_SECOND1 
(NAME = 'DB_SECOND1_1', FILENAME = 'C:\\SQLData\\DB_second1_1.ndf', SIZE = 3MB, MAXSIZE = 5MB, FILEGROWTH = 10%),
(NAME = 'DB_SECOND1_2', FILENAME = 'C:\\SQLData\\DB_second1_2.ndf', SIZE = 3MB, MAXSIZE = 5MB, FILEGROWTH = 10%),
(NAME = 'DB_SECOND1_3', FILENAME = 'C:\\SQLData\\DB_second1_3.ndf', SIZE = 3MB, MAXSIZE = 5MB, FILEGROWTH = 5%)
LOG ON
(NAME = 'DB_Log', FILENAME = 'C:\\SQLData\\DB_Log.ldf', SIZE = 1MB, MAXSIZE = 5MB, FILEGROWTH = 15%);

create database db_QLTHUVIEN
on primary
(name = 'db_Primary',filename= 'C:\db_Primary.mdf',size = 3MB,maxsize= 10MB,filegrowth= 10%),
filegroup db_second1
(name= 'db_second_1',filename= 'C:\db_second_1.ndf',size= 3MB, maxsize= 5MB,filegrowth= 10%),
(name= 'db_second_2',filename= 'C:\db_second_2.ndf',size= 3MB, maxsize= 5MB,filegrowth= 10%),
(name= 'db_second_3',filename= 'C:\db_second_3.ndf',size= 3MB, maxsize= 5MB,filegrowth= 5%)
log on 
(name= 'db_Log',filename= 'C:\db_Log.ldf',size= 1MB,maxsize= 5MB,filegrowth= 15%);

-- a
CREATE TABLE SACH (
  MASH INT PRIMARY KEY,
  TENSH VARCHAR(255),
  TACGIA VARCHAR(255),
  LOAI VARCHAR(255),
  TINHTRANG VARCHAR(255)
);

CREATE TABLE DOCGIA (
  MADG INT PRIMARY KEY,
  TENDG VARCHAR(255),
  TUOI INT,
  PHAI VARCHAR(10),
  DIACHI VARCHAR(255)
);

CREATE TABLE MUONSACH (
  MADG INT,
  MASH INT,
  NGAYMUON DATE,
  NGAYTRA DATE,
  FOREIGN KEY (MADG) REFERENCES DOCGIA(MADG),
  FOREIGN KEY (MASH) REFERENCES SACH(MASH)
);

--b. Thay đổi cấu trúc các bảng theo các yêu cầu sau:
---
--Thay đổi kiểu dữ liệu cột PHAI thành nvarchar(5).
--Thêm vào bảng DOCGIA cột điện thoại và Email với kiểu dữ liệu tùy chọn.
--Thêm vào bảng SACH cột nhà xuất bản với kiểu dữ liệu là nvarchar(20).

-- Thay đổi kiểu dữ liệu cột PHAI trong bảng DOCGIA thành nvarchar(5)
ALTER TABLE DOCGIA
ALTER COLUMN PHAI NVARCHAR(5);

-- Thêm cột Điện thoại và Email vào bảng DOCGIA với kiểu dữ liệu tùy chọn
ALTER TABLE DOCGIA
ADD DienThoai VARCHAR(20),
    Email VARCHAR(255);

-- Thêm cột Nhà xuất bản vào bảng SACH với kiểu dữ liệu là nvarchar(20)
ALTER TABLE SACH
ADD NhaXuatBan NVARCHAR(20);

-- bài tâp 1
declare @hoten varchar(20)
declare @tuoi int;

set @hoten= 'Ho ten 1'
set @tuoi= 20
-- in giá trị ra màn hình
select @hoten as HoTen
select @Tuoi as Tuoi
-- in giá trị ra màn hình
print 'Ho ten: ' + @hoten
print 'Tuoi' + cast(@tuoi as varchar)

--bài tập 2
-- Tạo cơ sở dữ liệu DB1
CREATE DATABASE DB1;
GO

-- Sử dụng cơ sở dữ liệu DB1
USE DB1;
GO

-- Tạo bảng SINHVIEN
CREATE TABLE SINHVIEN (
  MASV VARCHAR(10) PRIMARY KEY,
  HOTEN NVARCHAR(50),
  NGSINH DATE,
  DIEMTB FLOAT
);
GO

-- Nhập liệu vào bảng SINHVIEN
INSERT INTO SINHVIEN (MASV, HOTEN, NGSINH, DIEMTB)
VALUES ('SV001', 'Nguyen Van A', '2000-01-01', 8.5),
       ('SV002', 'Tran Thi B', '2001-02-03', 7.8),
       ('SV003', 'Le Van C', '1999-05-10', 9.2),
       ('SV004', 'Pham Thi D', '2002-09-15', 6.5);
GO

-- Khai báo biến @hoten và @ngsinh để lưu trữ họ tên và ngày sinh của sinh viên
DECLARE @hoten NVARCHAR(50);
DECLARE @ngsinh DATE;

-- Gán họ tên và ngày sinh của sinh viên có mã là 'SV004' vào hai biến trên
SET @hoten = (SELECT HOTEN FROM SINHVIEN WHERE MASV = 'SV004');
SET @ngsinh = (SELECT NGSINH FROM SINHVIEN WHERE MASV = 'SV004');

-- In giá trị của hai biến ra màn hình
SELECT @hoten AS HoTen, @ngsinh AS NgaySinh;

-- Khai báo biến @hoten và @ngsinh để lưu trữ họ tên và ngày sinh của sinh viên
DECLARE @hoten NVARCHAR(50);
DECLARE @ngsinh DATE;

-- Gán họ tên và ngày sinh của sinh viên có mã là 'SV004' vào hai biến trên
SET @hoten = (SELECT HOTEN FROM SINHVIEN WHERE MASV = 'SV004');
SET @ngsinh = (SELECT NGSINH FROM SINHVIEN WHERE MASV = 'SV004');

-- In giá trị của hai biến bằng lệnh PRINT
PRINT 'Sinh vien ' + @hoten + ' co ngay sinh la: ' + CONVERT(VARCHAR, @ngsinh, 103);

-- In giá trị của hai biến bằng lệnh SELECT
SELECT 'Sinh vien ' + @hoten + ' co ngay sinh la: ' + CONVERT(VARCHAR, @ngsinh, 103) AS ThongTin;

-- Kiểm tra điểm trung bình và in ra thông báo tương ứng
DECLARE @DIEMTB FLOAT;
SET @DIEMTB = (SELECT DIEMTB FROM SINHVIEN WHERE MASV = 'SV004');

IF @DIEMTB < 5
  PRINT 'Yeu';
ELSE IF @DIEMTB >= 5 AND @DIEMTB < 7
  PRINT 'Trung binh';
ELSE IF @DIEMTB >= 7 AND @DIEMTB < 8
  PRINT 'Kha';
ELSE
  PRINT 'Gioi';

-- Kiểm tra tuổi của sinh viên có mã là 'SV001' và in ra thông tin tương ứng
DECLARE @tuoi INT;
SET @tuoi = DATEDIFF(YEAR, (SELECT NGSINH FROM SINHVIEN WHERE MASV = 'SV001'), GETDATE());

IF @tuoi > 30
  SELECT HOTEN, @tuoi AS Tuoi, DIEMTB
  FROM SINHVIEN
  WHERE MASV = 'SV001';
ELSE
  PRINT 'Sinh vien nay duoi 30 tuoi';

-- Kiểm tra số lượng sinh viên có điểm trung bình > 5
IF EXISTS (SELECT * FROM SINHVIEN WHERE DIEMTB > 5)
  SELECT COUNT(*) AS TongSinhVien
  FROM SINHVIEN
  WHERE DIEMTB > 5;
ELSE
  PRINT 'Khong co sinh vien tren trung binh';
