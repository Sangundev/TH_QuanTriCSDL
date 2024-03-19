--TẠO CSDL (KIỂM TRA TỒN TẠI NẾU CÓ SẼ XÓA CSDL CŨ
USE master
GO
IF EXISTS (SELECT NAME FROM SYS.DATABASES WHERE NAME='QLSX')
	DROP DATABASE QLSX
GO
CREATE DATABASE QLSX
ON(NAME='QLSX_DATA',FILENAME='D:\SQL_HQTCSDL\QLSX.MDF')
LOG ON(NAME='QLSX_LOG',FILENAME='D:\SQL_HQTCSDL\QLSX.LDF')
GO
--CHỌN CSDL ĐỂ DÙNG
USE  QLSX
GO
--TẠO CÁC TABLE, KHÓA CHÍNH, RÀNG BUỘC
CREATE TABLE Loai
(
	MaLoai CHAR(5),
	TenLoai nvarchar(50),
	primary key(MALOAI)
)
GO
CREATE TABLE SanPham
(
	MaSP CHAR(5), 
	TenSP NVARCHAR(50) UNIQUE(TENSP), 
	MaLoai CHAR(5),
	PRIMARY KEY(MASP)
)
GO
CREATE TABLE NhanVien
(
	MaNV CHAR(5), 
	HoTen NVARCHAR(50) NOT NULL, 
	NgaySinh DATE CHECK(YEAR(GETDATE())-YEAR(NGAYSINH) BETWEEN 18 AND 55), 
	Phai BIT DEFAULT 0,
	PRIMARY KEY(MANV)
) 
GO
CREATE TABLE PhieuXuat
(
	MaPX INT IDENTITY(1,1), 
	NgayLap DATE, 
	MaNV CHAR(5),
	PRIMARY KEY(MAPX)
)
GO
CREATE TABLE CTPX
(
	MaPX INT, 
	MaSP CHAR(5), 
	SoLuong INT CHECK(SOLUONG>0),
	PRIMARY KEY(MAPX,MASP)
)
GO
--TẠO KHÓA NGOẠI VÀ MỐI QUAN HỆ CHO CÁC BẢNG

ALTER TABLE SANPHAM
ADD CONSTRAINT FK_SANPHAM_LOAI FOREIGN KEY(MALOAI)
    REFERENCES LOAI(MALOAI)

ALTER TABLE PHIEUXUAT
ADD CONSTRAINT FK_PHIEUXUAT_NHANVIEN FOREIGN KEY(MANV)
    REFERENCES NHANVIEN(MANV)

ALTER TABLE CTPX
ADD CONSTRAINT FK_CTPX_PHIEUXUAT FOREIGN KEY(MAPX)
    REFERENCES PHIEUXUAT(MAPX),
	CONSTRAINT FK_CTPX_SANPHAM FOREIGN KEY(MASP)
    REFERENCES SANPHAM(MASP)

--NHẬP DỮ LIỆU
INSERT LOAI VALUES
('1',N'Vật liệu xây dựng'),
('2',N'Hàng tiêu dùng'),
('3',N'Ngũ cốc')
SELECT * FROM Loai
INSERT SANPHAM VALUES
('1',N'Xi măng','1'),
('2',N'Gạch','1'),
('3',N'Gạo nàng hương','3'),
('4',N'Bột mì','3'),
('5',N'Kệ chén','2'),
('6',N'Đậu xanh','3')
SELECT * FROM SanPham
GO
SET DATEFORMAT DMY
GO
INSERT NhanVien VALUES
('NV01',N'Nguyễn Mai Thi','15/05/1982',	0),
('NV02',N'Trần Đình Chiến','02/12/1980',	1),
('NV03',N'Lê Thị Chi','23/01/1979',0)
SELECT * FROM NhanVien
GO
INSERT PhieuXuat(NgayLap,MANV)VALUES
('12/03/2010','NV01'),
('03/02/2010','NV02'),
('01/06/2010','NV03'),
('16/06/2010','NV01')
SELECT * FROM PhieuXuat
GO
INSERT CTPX VALUES
(1,	'1',	10),
(1,	'2',	15),
(1,	'3',	5),
(2,	'2',	20),
(3,	'1',	20),
(3,	'3',	25),
(4,	'5',	12)
SELECT * FROM CTPX

--Tạo các view sau:
--1.	Cho biết mã sản phẩm, tên sản phẩm, tổng số lượng xuất của từng sản phẩm trong năm 2010. 
--Lấy dữ liệu từ View này sắp xếp tăng dần theo tên sản phẩm.

create view v1 as
select a.MaSP,a.TenSP,sum(c.soluong) soluong
from SanPham a,PhieuXuat b, ctpx c
where a.MaSP=c.MaSP and c.MaPX=b.MaPX and year(b.NgayLap)=2010
group by a.MaSP,a.TenSP
order by a.TenSP

select * from v1

--2.	Cho biết mã sản phẩm, tên sản phẩm,
--tên loại sản phẩm mà đã được bán từ ngày 1/1/2010 đến 30/6/2010.

create view v2 as
select a.MaSP,a.TenSP,b.NgayLap
from SanPham a,PhieuXuat b, CTPX c
where a.MaSP=c.MaSP and c.MaPX=b.MaPX and
month(b.ngaylap) >= 1 and month(b.ngaylap) <= 30 
and day(b.ngaylap) >=1 and day(b.ngaylap) <= 30 and year(ngaylap)=2010

select * from v2

--3.	Cho biết số lượng sản phẩm trong từng loại sản phẩm
--gồm các thông tin: mã loại sản phẩm, tên loại sản phẩm, số lượng các sản phẩm.

create view v3 as
select c.MaLoai,c.TenLoai,count(d.soluong) SL
from SanPham a,PhieuXuat b,loai c,CTPX d
where a.MaSP=d.MaSP and c.MaLoai=a.MaLoai and d.MaPX=b.MaPX
group by c.MaLoai,c.TenLoai

select * from v3

--4.	Cho biết tổng số lượng phiếu xuất trong tháng 6 năm 2010.
create view V4 as
select sum(b.soluong) TONG_SL_PX_T6
from phieuxuat a, CTPX b
where a.MaPX=b.MaPX and year(a.NgayLap)=2010 and month(a.NgayLap)=6

select * from V4
--5.	Cho biết thông tin về các phiếu xuất mà nhân viên có mã NV01 đã xuất.

create view V5 as
select b.MaPX,b.MaSP,b.SoLuong,a.NgayLap
from phieuxuat a, CTPX b, NhanVien c
where a.MaPX=b.MaPX and c.MaNV=a.MaNV and c.MaNV=N'NV01'

select * from V5

--6.	Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 30.
create view v6 as
select a.hoten
from nhanvien a
where phai=1 and year(getdate())-year(ngaysinh) >=25 and 
year(getdate())-year(ngaysinh) < 30

select *from v6
--7.	Thống kê số lượng phiếu xuất theo từng nhân viên.
create view v7 as
select a.MaNV,a.HoTen , count(b.SoLuong) SLPX
from NhanVien a, CTPX b, phieuxuat c
where a.MaNV=c.manv and c.mapx=b.mapx
group by a.MaNV,a.HoTen

select *from v7
--8.	Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
create view v8 as
select a.tensp ,sum(c.soluong) sl_theo_sp
from sanpham a,CTPX c
where a.masp=c.masp 
group by a.tensp

select * from v8
--9.	Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.

create view v9 as
select top 1 with ties a.hoten, sum(c.soluong) sl
from nhanvien a, phieuxuat b,ctpx c
where a.manv=b.manv and c.mapx=b.mapx
group by a.hoten
order by sl desc

select * from v9
--10.	Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010.

create view v10 as
select top 1 with ties a.tensp, sum(c.soluong) sl
from sanpham a, phieuxuat b,ctpx c
where b.mapx=c.mapx and a.masp=c.masp
group by a.tensp
order by sl desc

select * from v10

--Tạo các Function sau:
--1.	Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: 
--số lượng xuất kho của tên sản phẩm đó trong năm này.
--(Chú ý: Nếu tên sản phẩm đó không tồn tại thì phải trả về 0)

CREATE FUNCTION f1(@TENSP nvarchar(50),@NAM int)
RETURNS INT
AS
	BEGIN
		DECLARE @SLXK INT
		IF exists(SELECT TENSP ,YEAR(NGAYLAP) FROM PhieuXuat A, CTPX B,SanPham C WHERE A.MaPX=B.MaPX AND B.MaPX=A.MaPX
		AND C.TenSP=@TENSP AND YEAR(NGAYLAP)=@NAM)
		SET @SLXK = (SELECT SUM(SoLuong) FROM CTPX A, SanPham B ,PhieuXuat C
						WHERE A.MaSP = B.MaSP AND A.MaPX=C.MaPX AND B.TenSP=@TENSP AND YEAR(C.NgayLap)=@NAM)
	ELSE 
	 SET @SLXK=0
	 
	 return @SLXK
	END
 
 SELECT TSL=DBO.F1(N'Gạch',2010)
--2.	Function F2 có 1 tham số nhận vào là mã nhân viên.
--Function trả về số lượng phiếu xuất của nhân viên truyền vào. Nếu nhân viên này không tồn tại thì trả về 0.
create function f2(@manv varchar(10) )
returns int
	as
		BEGIN
			DECLARE @slpx INT
			IF exists(select manv from PhieuXuat where manv=@manv )
				set @slpx = (select sum(SoLuong) from PhieuXuat a, CTPX b
							where a.MaPX=b.MaPX and manv=@manv)
			else
				set @slpx = 0
			return @slpx 
		END
select SLP= dbo.f2('NV02')

--3.	Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào. 
create function f3(@nam int )
returns table 
return 
(
	select a.masp,tensp,b.mapx,ngaylap,soluong
	from SanPham a,PhieuXuat b,CTPX c
	where a.masp=c.MaSP and b.MaPX=c.MaPX and year(b.NgayLap)=@nam
)

select*from dbo.f3(2010)
--4.	Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó. Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.
create function f4 (@MANV VARCHAR(10))
RETURNS @DSPX TABLE
(
	MANV NVARCHAR(10),
	TENNV NVARCHAR(50),
	MAPX VARCHAR(10),
	NGAYLAP DATE
)
AS

	BEGIN 
	IF(@MANV IS NULL)
		INSERT @DSPX
		SELECT A.MANV,HOTEN,MAPX,NGAYLAP
		FROM NhanVien A, PhieuXuat B
		WHERE A.MaNV=B.MaNV
	ELSE
		INSERT @DSPX
		SELECT A.MANV,HOTEN,MAPX,NGAYLAP
		FROM NhanVien A, PhieuXuat B
		WHERE A.MaNV=B.MaNV AND A.MaNV=@MANV
	RETURN
	END 

SELECT *FROM DBO.F4(NULL)
--5.	Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.
create function f5 (@mapx nvarchar(10))
returns nvarchar(50)
	begin 
		DECLARE @nhanvien nvarchar(50)
		set @nhanvien = (select a.HoTen from NhanVien a,PhieuXuat b where a.MaNV=b.MaNV and b.MaPX=@mapx)
		return @nhanvien
	end

select dbo.f5(2)
--6.	Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2.

CREATE FUNCTION F6(@T1 DATE,@T2 DATE)
RETURNS TABLE
AS
	RETURN
			(
				SELECT *
				FROM PhieuXuat
				WHERE NGAYLAP BETWEEN @T1 AND @T2
			)

SELECT *FROM DBO.F6('01/06/2010','30/06/2010')

--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.

CREATE FUNCTION F7 (@MAPX VARCHAR(10))
RETURNS INT 
AS
	BEGIN
		DECLARE @NGAY INT
			SET @NGAY = (SELECT DAY(NgayLap) FROM PhieuXuat
						WHERE MAPX=@MAPX)
			RETURN @NGAY
	END
SELECT NGAY=DBO.F7(1)
--Tạo các Procedure sau:
--1.	Procedure tên là P1 cho có 2 tham số sau:
--●	1 tham số nhận vào là: tên sản phẩm.
--●	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này
------trong năm 2010 (Không viết lại truy vấn, hãy sử dụng Function F1 ở câu 4 để thực hiện)

create proc P1(@tensp nvarchar(50))
as
	begin 
			select count(b.SoLuong) sl
			from SanPham a, CTPX b
			where a.MaSP=b.MaSP and a.TenSP=@tensp
	end

P1 N'Gạch'

--2.	Procedure tên là P2 có 2 tham số sau:
--	1 tham số nhận vào là: tên sản phẩm.
--	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010 (Chú ý: Nếu tên sản phẩm này không tồn tại thì trả về 0)
CREATE PROC P2(@X nvarchar(50))
AS
	BEGIN
		if EXISTS(SELECT tensp FROM SanPham WHERE tensp=@X)
			SELECT A.MASP,TENSP,TONGSL_XUAT=SUM(SL)
			FROM SanPham A,HOADON B
			WHERE A.MAKH=B.MAKH AND month(ngay)=4 and month(ngay) >=6 and year(ngay)=2010
			group by A.MASP,TENSP
	ELSE
		PRINT N'0'
	END
 P2 N'Xi măng'
--3.	Procedure tên là P3 chỉ có duy nhất 1 tham số nhận vào là tên sản phẩm. 
--Trong Procedure này có khai báo 1 biến cục bộ được gán giá trị là: 
--số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010. Việc gán trị này chỉ được thực hiện bằng cách gọi Procedure P2.

--4.	Procedure P4 để INSERT một record vào trong table LOAI. Giá trị các field là tham số truyền vào.
--5.	Procedure P5 để DELETE một record trong Table NhânViên theo mã nhân viên. Mã NV là tham số truyền vào.

--Viết các trigger để thực hiện các ràng buộc sau:
--1.	Chỉ cho phép một phiếu xuất có tối đa 5 chi tiết phiếu xuất.
--2.	Chỉ cho phép một nhân viên lập tối đa 10 phiếu xuất trong một ngày.
--3.	Khi người dùng viết 1 câu truy vấn nhập 1 dòng cho bảng chi tiết phiếu xuất thì CSDL kiểm tra, nếu mã phiếu xuất mới đó chưa tồn tại trong bảng phiếu xuất thì CSDL sẽ không cho phép nhập và thông báo lỗi “Phiếu xuất này không tồn tại”. Hãy viết 1 trigger đảm bảo điều này.

 
 ----CU PHAP TAOJ PROC
 create proc (@thamso1 kieudl(do lai ), @@thamso1 kieudl(do lai )............)
 as

	begin 
	----------cau truc lenh SQL
	END

---- goi thu tuc 
ten thu tuc gia tri tham so 
FILE BACKUP CỦA BÀI 02
Đã đăng vào 26 thg 11
1
﻿CREATE TRIGGER TÊN
ON TÊN TABLE
FOR THÊM (INSERT), XOÁ (DELETE), SỬA  (UPDATE)
AS
	BEGIN
		CODE SQL
	END

--1.	Thực hiện việc kiểm tra các ràng buộc khóa ngoại.
CREATE TRIGGER TRG01
ON HOADON
FOR INSERT,UPDATE
AS
	BEGIN
		DECLARE @MAKH CHAR(10)
		SET @MAKH=(SELECT MAKH FROM inserted)

		IF NOT EXISTS(SELECT MAKH FROM KHACHHANG WHERE MAKH=@MAKH)
			BEGIN
				RAISERROR(N'KHÔNG TÌM THẤY MÃ KHÁCH HÀNG NÀY',16,1)
				ROLLBACK TRANSACTION
			END
	END
--2.	Không cho phép CASCADE DELETE trong các ràng buộc khóa ngoại. 
--Ví dụ không cho phép xóa các HOADON nào có SOHD còn trong table CTHD.

--3.Không cho phép user nhập vào hai vật tư có cùng tên.
CREATE TRIGGER TRG03
ON VATTU
FOR INSERT,UPDATE
AS
	BEGIN
		IF (SELECT COUNT(V.TENVT) FROM VATTU V,inserted I WHERE V.TENVT=I.TENVT)>1
			BEGIN
				RAISERROR(N'KHÔNG ĐƯỢC NHẬP TRÙNG TÊN VẬT TƯ',16,1)
				ROLLBACK TRANSACTION
			END
	END
--4.Khi user đặt hàng thì KHUYENMAI là 5% nếu SL > 100, 10% nếu SL > 500.
CREATE TRIGGER TRG04
ON CTHD
FOR INSERT,UPDATE
AS
	BEGIN
		UPDATE CTHD
		SET KHUYENMAI=IIF(SL>500,0.1*SL*GIABAN,IIF(SL>100,0.05*SL*GIABAN,0))
	END

--5.Chỉ cho phép mua các mặt hàng có số lượng tồn lớn hơn hoặc bằng số lượng cần mua và tính lại số lượng tồn mỗi khi có đơn hàng.
--6.Không cho phép user xóa một lúc nhiều hơn một vật tư.
--7.Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.
--8.Mỗi hóa đơn có tổng trị giá tối đa 50000000.
--9.Không được phép bán hàng lỗ quá 50%.
--10.Chỉ bán mặt hàng Gạch (các loại gạch) với số lượng là bội số của 100.
