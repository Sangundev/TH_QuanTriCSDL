create database Quanlytourdulich
use Quanlytourdulich

create table DUKHACH(
MAKH char(10) not null primary key, 
TENKH nvarchar(100),
DIACHI nvarchar(100) )

create table PHIEUDANGKY(
SOPHIEU char(10) not null primary key, 
NGAYDK date,
MAKH char(10) default null, 
TONGTIEN int )
alter table PHIEUDANGKY add constraint FK_MAKH foreign key(MAKH)
references DUKHACH(MAKH);

create table THONGTINDANGKY(
SOPHIEU char(10) default null,
MATOUR char(10) default null, 
SONGUOI int
)

alter table THONGTINDANGKY add constraint FK_SOPHIEU foreign key(SOPHIEU)
references PHIEUDANGKY(SOPHIEU);

create table TOUR(
MATOUR char(10) not null primary key,
LOTRINH nvarchar(100),
HANHTRINH nvarchar(100),
GIATOUR int 
)
alter table THONGTINDANGKY add constraint FK_MATOUR foreign key(MATOUR)
references TOUR(MATOUR);

insert into DUKHACH values ('KH1','CONG TY TOAN THANG ','TAN BINH');
insert into DUKHACH values ('KH2','NGUYEN VAN HUNG ','QUAN 1');
insert into DUKHACH values ('KH3','LE THANH TUAN ','QUAN 5');
insert into DUKHACH values ('KH4','CONG TY HUNG THINH ','QUAN 7');

insert into TOUR values ('T1','TPHCM-PHANTHIET ','3 NGAY 2 DEM',2500000);
insert into TOUR values ('T2','TPHCM-NHATRANG ','4 NGAY 3 DEM',5000000);
insert into TOUR values ('T3','TPHCM-HOIAN ','6 NGAY 5 DEM',8500000);
insert into TOUR values ('T4','TPHCM-HALONG ','5 NGAY 4 DEM',10000000);

insert into PHIEUDANGKY values ('01','2012-10-10','KH1',0);
insert into PHIEUDANGKY values ('02','2012-10-27','KH2',0);
insert into PHIEUDANGKY values ('03','2012-11-01','KH3',0);
insert into PHIEUDANGKY values ('04','2012-11-10','KH1',0);
insert into PHIEUDANGKY values ('05','2012-11-15','KH4',0);

insert into THONGTINDANGKY values ('01','T1',25);
insert into THONGTINDANGKY values ('02','T1',5);
insert into THONGTINDANGKY values ('03','T2',2);
insert into THONGTINDANGKY values ('04','T2',20);
insert into THONGTINDANGKY values ('05','T2',15);

--------SQL------------------------

--1. Tạo Store Procedure tên P1 tìm danh sách khách hàng đăng ký tour. Thông tin hiển 
--thị gồm : MÃ TOUR, LỘ TRÌNH, HÀNH TRÌNH, MAKH, TENKH. Tham số truyền
--vào là MATOUR, nếu tour chưa có khách hàng đăng ký thì thông báo. (1.5 điểm)

create alter proc P1(@matour char(10))
as
	begin
		if exists (select matour from THONGTINDANGKY where MATOUR=@matour)
			select d.matour ,lotrinh,hanhtrinh,a.makh,tenkh
			from DUKHACH a,PHIEUDANGKY b,THONGTINDANGKY c,TOUR d
			where a.MAKH=b.MAKH and b.SOPHIEU=c.SOPHIEU and c.MATOUR=d.MATOUR and c.MATOUR=@matour
		else
			print'chua dang ky'
	end	

p1 'T3'
--2. Tạo Function tên F1 trả về tổng số người đăng ký cho từng tour, nếu tour nào chưa có
--khách đăng ký thì trả về giá trị 0. Tham số là mã tour. (1.5 điểm)

create function F1(@matour char(10))
returns int
as
	begin 
	declare @tong int
		if exists (select matour from THONGTINDANGKY where MATOUR=@matour)
		set @tong = (select sum(songuoi) from thongtindangky where matour=@matour)
		else
		set @tong = 0

		return @tong
	end
select SLN_DK=dbo.F1('T2')
--3. Tạo Store Procedure tên P2 tìm các tour có số lượng người đăng ký nhiều nhất. 
--Thông tin hiển thị gồm: MATOUR, LOTRINH, HANHTRINH,
--TONGSONGUOIDANGKY. (1.5 điểm)

create proc P2 
as
	begin
		select top 1 with ties a.matour, lotrinh,hanhtrinh,sum(songuoi) as slndk
		from tour a,thongtindangky b
		where a.MATOUR=b.MATOUR 
		group by a.matour, lotrinh,hanhtrinh
		order by slndk desc
	end
p2

--4. Tạo Function tên F2 trả về table thống kê số lượng tour đăng ký cho từng tháng của 
--năm (tham số là năm). Thông tin hiển thị gồm: NAM, THANG, SOLUONGTOUR. (1.5 điểm)
create function F2 (@nam int )
returns @DX table(
NAM int,
THANG int, 
SOLUONGTOUR int )
as
	begin 
		insert @DX
		select year(ngaydk),month(NGAYDK),SOLUONGTOUR=count(b.matour)
		from phieudangky a,thongtindangky b
		where a.SOPHIEU=b.SOPHIEU and year(ngaydk)=@nam
		group by year(ngaydk),month(NGAYDK)
	return
	end 
select* from dbo.F2(2012)

--5. Tạo Store Procedure tên P3 thống kê doanh thu cho từng tour. Thông tin hiển thị 
--gồm : MÃ TOUR, LỘ TRÌNH, HÀNH TRÌNH, TỔNG SỐ NGƯỜI ĐĂNG KÝ, 
--DOANH THU (DOANHTHU=tổng số người đăng ký*giá tour). Thống kê cho tất cả 
--các tour kể cả những tour chưa có khách đăng ký, trong đó tổng số người đăng ký 
--được gọi ở hàm F1 ở câu 2. (2 điểm)

create alter proc P3 
as
	begin
		select b.MATOUR,b.LOTRINH,b.HANHTRINH,sum_nguoi_dk=dbo.F1(b.MATOUR),DOANHTHU=SUM(a.SONGUOI*GIATOUR)
		from tour b left join thongtindangky a on a.MATOUR=b.MATOUR
		group by b.MATOUR,b.LOTRINH,b.HANHTRINH
	end

