create database QL_RCP
USE QL_RCP

create table THELOAI(
MATL varchar(10) not null primary key,
TENTL nvarchar(100) ) 

create table PHIM(
MAPHIM varchar(10) not null primary key, 
TENPHIM nvarchar(100),
SOLANCHIEU int ,
MATL varchar(10) not null) 

alter table PHIM add constraint FK_MATL foreign key(MATL)
references THELOAI(MATL);

create table RAP(
MARAP varchar(10) not null primary key, 
TENRAP nvarchar(100),  
DIACHI nvarchar(100) )


create table LICHCHIEU (
MAXC varchar(10) not null primary key, 
MARAP varchar(10) not null, 
MAPHIM varchar(10) not null, 
NGAYCHIEU date, 
SOLUONGVE int, 
GIAVE int) 

alter table LICHCHIEU add constraint FK_MARAP foreign key(MARAP)
references RAP(MARAP);

alter table LICHCHIEU add constraint FK_MAPHIM foreign key(MAPHIM)
references PHIM(MAPHIM);

insert into THELOAI values ('L1','HANH DONG')
insert into THELOAI values ('L2','CHIEN TRANH')
insert into THELOAI values ('L3','HAI')

insert into RAP values ('R01','THANG LONG ','TAN BINH')
insert into RAP values ('R02','HUNG VUONG ','QUAN 10')
insert into RAP values ('R03','THONG NHAT ','QUAN 1')
insert into RAP values ('R04','GIAI PHONG ','PHU NHUAN')	


insert into PHIM values ('P01','BAY RONG',0,'L1')
insert into PHIM values ('P02','CANH DONG HOANG',0,'L2')
insert into PHIM values ('P03','KHI DAN ONG CO BAU ',0,'L3')
insert into PHIM values ('P04','DONG MAU ANH HUNG ',0,'L1')
insert into PHIM values ('P05','BIET DONG SAI GON',0,'L2')

insert into LICHCHIEU values ('01','R01','P01','2013-04-01',150,120000)
insert into LICHCHIEU values ('02','R03','P01','2013-04-01',130,110000)
insert into LICHCHIEU values ('03','R04','P02','2013-04-30',250,170000)
insert into LICHCHIEU values ('04','R02','P02','2013-05-01',100,180000)
insert into LICHCHIEU values ('05','R03','P03','2013-05-19',350,140000)
insert into LICHCHIEU values ('06','R02','P03','2013-06-01',160,160000)
insert into LICHCHIEU values ('07','R01','P04','2013-09-02',90,120000)

----------------SQL--------------------------------
--2.1 . Tạo TRIGGER  thực hiện yêu cầu sau:   
 --- Tự động cập nhật số lần chiếu (trong Table PHIM) tại các rạp cho từng phim. 
 --Nếu phim chưa được chiếu ở rạp nào thì cập nhật giá trị 0. (1.5 điểm) 


--2.2. Tạo View tên V1 tìm các rạp chiếu các phim thuộc thể loại chiến tranh được chiếu trong tháng 4 năm 2013. 
--Thông tin hiển thị gồm : MÃ RẠP, TÊN RẠP, TÊN PHIM, NGÀY CHIẾU (1.0 điểm) 
create View V1 as
	select b.MARAP,c.TENRAP,a.TENPHIM,NGAYCHIEU
	from PHIM a,LICHCHIEU b,RAP c
	where a.MAPHIM=b.MAPHIM  and b.MARAP=c.MARAP and year(b.NGAYCHIEU)=2013 and month(b.NGAYCHIEU)=4
SELECT* FROM V1

--2.3. Tạo Procedure tên P1 tìm các phim chưa được chiếu. Thông tin hiển thị gồm : MÃ PHIM,  TÊN PHIM (1.0 điểm) 

create proc P1 as
	BEGIN
		SELECT MAPHIM,TENPHIM from PHIM 
		WHERE MAPHIM NOT IN (SELECT MAPHIM FROM LICHCHIEU )
	END
p1

--2.4. Tạo Function tên F1 trả về tổng số lượng vé theo từng phim, nếu phim nào chưa được chiếu thì
--trả về giá trị 0. Tham số là mã phim. (1.5 điểm)
create function F1 (@MAPHIM varchar(10))
returns int
as
	begin
		declare @slve int
		if exists (select  MAPHIM from LICHCHIEU where MAPHIM=@MAPHIM)
			SET @slve = (SELECT SUM(SOLUONGVE) FROM LICHCHIEU WHERE MAPHIM=@MAPHIM)
		else
			SET @slve=0
		return @slve
	end
SELECT SLV=DBO.F1('P04')

--2.5. Tạo Procedure tên P2 tính số phim chiếu của rạp, tham số truyền vào là MÃ RẠP, tham số trả
--về là số phim chiếu của rạp đó, phim nào chưa chiếu thì trả về 0. (1.5 điểm)

CREATE ALTER PROC P2 (@MARAP VARCHAR(10), @TONGSOP INT OUTPUT)
AS
	BEGIN
		if exists (select  MAPHIM from PHIM where MAPHIM NOT IN (SELECT MAPHIM FROM LICHCHIEU))
			SET @TONGSOP =(SELECT COUNT(MAPHIM) FROM LICHCHIEU WHERE MARAP=@MARAP )
		else
			SET @TONGSOP =0
	END

DECLARE @X INT
exec P2 'R03',@X OUTPUT
PRINT @X
--2.6. Tạo Function tên F2 thống kê tổng số doanh thu của từng phim theo từng tháng của năm (phim
--nào chưa công chiếu thì doanh thu = 0). Tham số là MÃ PHIM, nếu không truyền vào thì hiển thị
--tất cả các phim. Thông tin hiển thị gồm : MÃ PHIM, TÊN PHIM, THÁNG, NĂM, TỔNG SỐ
--LƯỢNG VÉ, TỔNG DOANH THU (Tổng doanh thu = Tổng số lượng vé * giá vé) trong đó
--TỔNG SỐ LƯỢNG VÉ được gọi hàm F1 của câu 2.4 (1.5 điểm)

create function F2 (@MAPHIM varchar(10))
returns @DSP TABLE
(
	MAPHIM VARCHAR(10),
	TENPHIM NVARCHAR(50),
	THANG INT,
	NAM INT,
	TONGSL_VE INT,
	TONGDOANHTHU INT
)
AS
BEGIN
	IF(@MAPHIM IS NULL)
		INSERT @DSP
		SELECT A.MAPHIM,TENPHIM,MONTH(NGAYCHIEU),YEAR(NGAYCHIEU),dbo.f1(A.MAPHIM),SUM(SOLUONGVE*GIAVE)
		FROM PHIM A, LICHCHIEU B
		WHERE A.MAPHIM=B.MAPHIM
		GROUP BY A.MAPHIM,TENPHIM,MONTH(NGAYCHIEU),YEAR(NGAYCHIEU)
	ELSE
		INSERT @DSP
		SELECT A.MAPHIM,TENPHIM,MONTH(NGAYCHIEU),YEAR(NGAYCHIEU),dbo.f1(A.MAPHIM),SUM(SOLUONGVE*GIAVE)
		FROM PHIM A, LICHCHIEU B
		WHERE A.MAPHIM=B.MAPHIM AND A.MAPHIM=@MAPHIM
		GROUP BY A.MAPHIM,TENPHIM,MONTH(NGAYCHIEU),YEAR(NGAYCHIEU)
	RETURN 
END

SELECT *FROM DBO.F2(null)

//////======================
-----TEST KIEM TRA ---
--2.2. Tạo View tên V1 tìm các rạp chiếu các phim thuộc thể loại chiến tranh được chiếu trong tháng 4 
--năm 2013. Thông tin hiển thị gồm : MÃ RẠP, TÊN RẠP, TÊN PHIM, NGÀY CHIẾU (1.0 điểm)

create alter view V11 as
select a.MARAP, b.TENRAP,C.tenphim,a.ngaychieu
from LICHCHIEU a, RAP b, PHIM c
where a.marap=b.marap and a.maphim = c.maphim and year(ngaychieu)=2013 
and month(ngaychieu)=4

select* from V11

2.3. Tạo Procedure tên P1 tìm các phim chưa được chiếu. Thông tin hiển thị gồm : MÃ PHIM, TÊN 
PHIM (1.0 điểm)
create proc P11 as
	begin
		select maphim,tenphim
		from phim
		where maphim not in (select maphim from lichchieu )
	end
p11
2.4. Tạo Function tên F1 trả về tổng số lượng vé theo từng phim, nếu phim nào chưa được chiếu thì 
trả về giá trị 0. Tham số là mã phim. (1.5 điểm)
create function F11 (@maphim varchar(10))
returns int 
as
	begin 
	declare @doanhthu int
		set @doanhthu=( select sum(soluongve)
		from lichchieu
		where maphim=@maphim)
	return @doanhthu
	end
select doanhthu=dbo.f11('P02')
2.5. Tạo Procedure tên P2 tính số phim chiếu của rạp, tham số truyền vào là MÃ RẠP, tham số trả 
về là số phim chiếu của rạp đó, phim nào chưa chiếu thì trả về 0. (1.5 điểm)

2.6. Tạo Function tên F2 thống kê tổng số doanh thu của từng phim theo từng tháng của năm (phim 
nào chưa công chiếu thì doanh thu = 0). Tham số là MÃ PHIM, nếu không truyền vào thì hiển thị 
tất cả các phim. Thông tin hiển thị gồm : MÃ PHIM, TÊN PHIM, THÁNG, NĂM, TỔNG SỐ 
LƯỢNG VÉ, TỔNG DOANH THU (Tổng doanh thu = Tổng số lượng vé * giá vé) trong đó 
TỔNG SỐ LƯỢNG VÉ được gọi hàm F1 của câu 2.4 (1.5 điểm)

create function f22(@maphim varchar(10))
returns @DLX table (
	MAPHIM varchar(10),
	TENPHIM nvarchar(100),
	THANG int,
	NAM int,
	TSLV int,
	TDT int
 )
 as
	 begin 
		if(@maphim is null )
			INSERT @DLX
			select a.maphim,a.tenphim,month(ngaychieu),year(ngaychieu),dbo.f11(a.maphim),sum(soluongve*giave)
			from phim a,lichchieu b
			where a.maphim=b.maphim
			group by a.maphim,a.tenphim,month(ngaychieu),year(ngaychieu)
		else
			INSERT @DLX
			select a.maphim,a.tenphim,month(ngaychieu),year(ngaychieu),dbo.f11(a.maphim),sum(soluongve*giave)
			from phim a,lichchieu b
			where a.maphim=b.maphim and a.maphim=@maphim
			group by a.maphim,a.tenphim,month(ngaychieu),year(ngaychieu)
	return
	 end

