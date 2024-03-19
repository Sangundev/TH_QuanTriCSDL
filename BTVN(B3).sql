USE QL_KHACHSAN
 TẠO STORE PROCEDURE
--1. Tạo Procedure tìm phòng theo loại phòng. Tham số truyền là loại
--phòng, nếu loại phòng không truyền vào thì hiển thị tất cả các phòng,
--không tìm thấy hoặc sai dữ liệu thì có thì hiển thị thông báo.
create proc p1(@loaiphong nvarchar(50))
as
	begin
		if EXISTS (select loaiphong  from phong where loaiphong=@loaiphong)
			select maphong,loaiphong,tang,giaphong
			from phong
			where loaiphong=@loaiphong
		else if(@loaiphong is null )
			select* from phong
		else 
			print 'sai du lieu '
	end

p1 'B'

--2. Tạo Procedure tìm hóa đơn theo năm. Tham số truyền là năm, nếu năm
--không truyền vào thì hiển thị tất cả hóa đơn, không tìm thấy hoặc sai
--dữ liệu thì có thì hiển thị thông báo. Thông tin hiển thị gồm MAHD,
--NGAYLAP, TENNV.

create alter proc p2 (@nam int)
as
	BEGIN 
		IF EXISTS (select year(ngaylap) from hoadon where year(ngaylap)=@nam)
			select mahd,ngaylap, tennv 
			from nhanvien a,hoadon b
			where a.manv=b.manv and year(ngaylap)=@nam
		else if(@nam is null )
			select *from hoadon
		else
			print'khong tim thay du lieu hoac nhap sai '
	END

p2 2013


--3. Tạo Procedure thanh toán tiền phòng cho khách theo từng hóa đơn.
--Thông tin hiển thị: MAHD, NGAYLAP, TENKH, MAPHONG, LOAIPHONG,
--TANG,SONGAY,GIAPHONG, KHUYENMAI, THANHTIEN = SONGAY *GIAPHONG - KHUYENMAI.
--Tiền KHUYENMAI được tính như sau:
--+ Nếu thuê trên 2 tuần thì giảm 10% của SONGAY*GIAPHONG
--+ Nếu thuê trên 1 tuần thì giảm 5% của SONGAY*GIAPHONG
--+ Ngược lại thì không khuyến mãi.

create proc p3
as
	begin
		select c.mahd,ngaylap,tenkh,d.maphong,d.loaiphong,
		thanhtien=songay*giaphong - iif(songay>14,0.1*songay*giaphong,iif(songay>7,0.05*songay*giaphong,0))
		from khach a,chitiethoadon b, hoadon c,phong d
		where a.makh=c.makh and c.mahd=b.mahd and b.maphong=d.maphong
	end
 p3

----4. Tạo Procedure thống kê doanh thu theo từng táng của các năm. Thông
--tin hiển thị: THANG, NAM, DOANHTHU (doanh thu là tổng số tiền thuê
--phòng tính được trong chi tiết hóa đơn)


create proc p4 
as
	begin
		select  month(a.ngaylap) ,year(a.ngaylap) ,danhthu=sum(songay*giaphong)
		from hoadon a, chitiethoadon b,phong c
		where a.mahd=b.mahd and b.maphong=c.maphong
		group by month(a.ngaylap) ,year(a.ngaylap)
		order by danhthu desc
	end

p4

--5. Tạo Procedure tìm phòng có số lần thuê nhiều lần nhất. Thông tin hiển
--thị gồm: MAPHONG, LOAIPHONG, TANG, SOLANTHUE.

create proc p5
as
	begin
		select top 1 with ties a.maphong,loaiphong,tang,solanthue=count(mahd)
		from phong a,chitiethoadon b
		where a.maphong=b.maphong
		group by a.maphong,loaiphong,tang
		order by solanthue desc
	end

p5
--6. Tạo Procedure thống kê số khách trong và ngoài nước thuê phòng theo
--từng phòng. Thông tin hiển thị: MAPHONG, LOAIPHONG, SỐ KHÁCH
--TRONG NƯỚC, SỐ KHÁCH NƯỚC NGOÀI.
---cach 1

CREATE PROC CAU6 
AS
BEGIN
	SELECT P.MAPHONG, LOAIPHONG, 
	N'SỐ KHÁCH TRONG NƯỚC'=SUM(CASE WHEN QUOCTICH=N'VIỆT NAM' THEN 1 ELSE 0 END), 
	N'SỐ KHÁCH NƯỚC NGOÀI'=SUM(CASE WHEN QUOCTICH<>N'VIỆT NAM' THEN 1 ELSE 0 END)
	FROM KHACH K, HOADON H,PHONG P, CHITIETHOADON C
	WHERE K.MAKH=H.MAKH AND C.MAHD=H.MAHD AND C.MAPHONG =P.MAPHONG
	GROUP BY P.MAPHONG,LOAIPHONG

END
-- cach 2 
CREATE PROC CAU6 
AS
BEGIN
	SELECT P.MAPHONG, LOAIPHONG, 
	N'SỐ KHÁCH TRONG NƯỚC'=SUM(IIF(QUOCTICH=N'VIỆT NAM',1,0)), 
	N'SỐ KHÁCH NƯỚC NGOÀI'=SUM(IIF(QUOCTICH<>N'VIỆT NAM',1,0))
	FROM KHACH K, HOADON H,PHONG P, CHITIETHOADON C
	WHERE K.MAKH=H.MAKH AND C.MAHD=H.MAHD AND C.MAPHONG =P.MAPHONG
	GROUP BY P.MAPHONG,LOAIPHONG

END

exec cau6

 TẠO FUNCTION
7. Tạo Function tính doanh thu của từng phòng. Tham số là MAPHONG,
nếu phòng chưa cho thuê thì trả về 0. Kiểm tra lại kết quả bằng COMPUTE.

create function f7 (@maphong varchar(3))
returns int
as
	begin 
	declare @doanhthu int
		IF exists (select maphong from phong where maphong=@maphong)
			set @doanhthu = (select doanhthu = sum(giaphong*songay)
						from phong a, chitiethoadon b
						where a.maphong=b.maphong and a.maphong=@maphong)
		else
			set @doanhthu=0
	return @doanhthu
	end 
SELECT DOANHTHU=DBO.F7('A1')
8. Tạo Function tính số lượng hóa đơn được lập bởi nhân viên. Tham số là
MANV, nếu nhân viên chưa lập hóa đơn thì trả về 0. Kiểm tra lại kết quả
bằng COMPUTE.

create function f8 (@manv varchar(10))
returns int
as
	begin 
		declare @slhd int
		if exists(select manv from hoadon where manv=@manv)
			set @slhd=(select count(manv) slhd from hoadon where manv=@manv)
		else
			set @slhd = 0
	return @slhd
	end 

select SLHD= dbo.f8('NV04')

9. Tạo Function tính trị giá của từng hóa đơn. Sau đó cập nhật tổng trị giá
của từng hóa đơn vào Table HOADON.

create function f9 (@MAHD char(10))returns numeric(10,0)as	begin	declare @GTHD numeric(10,0)	SET  @GTHD = (SELECT SUM(SONGAY*GIAPHONG) FROM CHITIETHOADON b , PHONG c						where b.maphong=c.maphong AND MAHD=@MAHD)		RETURN @GTHD	endSELECT DBO.f9('HD01')UPDATE HOADONSET TONGTRIGIA = DBO.f9(MAHD)

10. Tạo Function tính tiền phòng cho khách. Tham số là MAKH.

create alter function F10 (@X varchar(10))
returns int
as
	begin 
		declare @slhd int
		if exists(select makh from hoadon where makh=@X)
		set @slhd=(select TIENPHONG=sum(SONGAY*GIAPHONG)
			from hoadon b,chitiethoadon c, phong d
			where b.MAHD=c.MAHD and c.MAPHONG=d.MAPHONG and b.MAKH=@X)
		else
		set @slhd=0
		return @slhd
	end 

select TP=dbo.f10('KH04')