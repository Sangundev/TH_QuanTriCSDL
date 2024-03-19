create database QL_SP
use QL_SP

create table SANPHAM(
MASP varchar(10) not null primary key,
TENSP nvarchar(100),
XUATXU nvarchar(100) )

create table KHACHHANG(
MAKH varchar(10) not null primary key, 
TENKH nvarchar(100), 
DIACHI nvarchar(100))

create table DONDATHANG(
MADH varchar(10) not null primary key, 
NGAYDH date,
MAKH varchar(10) default null )

alter table DONDATHANG add constraint FK_MAKH foreign key(MAKH)
references KHACHHANG(MAKH);

create table CHITIETDONHANG(
MADH varchar(10) not null, 
MASP varchar(10) not null , 
SOLUONGDAT int 
primary key (MADH,MASP))

alter table CHITIETDONHANG add constraint FK_MADH foreign key(MADH)
references DONDATHANG(MADH);

alter table CHITIETDONHANG add constraint FK_MASP foreign key(MASP )
references SANPHAM(MASP );

set dateformat dmy

insert into SANPHAM values ('SP01',N'MÁY LẠNH TODHIBA 1HP ',N'NHẬT');
insert into SANPHAM values ('SP02',N'MÁY GIẶT SANYO 6KG ',N'NHẬT');
insert into SANPHAM values ('SP03',N'TIVI SAMSUNG 21INCH ',N'HÀN QUỐC');
insert into SANPHAM values ('SP04',N'ĐẦU KARAOKE TIẾN ĐẠT ',N'VIỆT NAM');
insert into SANPHAM values ('SP05',N'TỦ LẠNH HITACHI 20L ',N'NHẬT');

insert into KHACHHANG values ('KH01',N'NGUYỄN THỊ XUÂN ',N'TÂN BÌNH');
insert into KHACHHANG values ('KH02',N'TRẦN VĂN ĐẠT ',N'BÌNH THẠNH');
insert into KHACHHANG values ('KH03',N'CAO VĂN TÌNH ',N'TÂN BÌNH');
insert into KHACHHANG values ('KH04',N'DƯƠNG SƠN ',N'PHÚ NHUẬN');
insert into KHACHHANG values ('KH05',N'NGÔ THỊ HỒNG ',N'QUẬN 10');	

insert into DONDATHANG values ('01','10/10/2011','KH01');
insert into DONDATHANG values ('02','15/11/2011','KH03');
insert into DONDATHANG values ('03','27/12/2011','KH02');
insert into DONDATHANG values ('04','27/12/2011','KH01');
insert into DONDATHANG values ('05','01/12/2011','KH04');

insert into CHITIETDONHANG values ('01','SP03',3);
insert into CHITIETDONHANG values ('01','SP04',2);
insert into CHITIETDONHANG values ('02','SP02',1);
insert into CHITIETDONHANG values ('03','SP01',1);
insert into CHITIETDONHANG values ('03','SP03',4);
insert into CHITIETDONHANG values ('03','SP04',2);
insert into CHITIETDONHANG values ('04','SP03',2);
insert into CHITIETDONHANG values ('05','SP01',3);
insert into CHITIETDONHANG values ('05','SP02',1);

------SQL----

Câu 2: Thực hiện các truy vấn sau bằng ngôn ngữ SQL (8 điểm)

a. Tạo Trigger thực hiện các công việc sau: (2 điểm)
- Kiểm tra một đơn hàng không quá 3 sản phẩm.
- Tạo thêm cột tổng số lượng TONGSOLUONG vào Table SANPHAM sau đó tự động cập
nhật tổng số lượng đặt hàng của sản phẩm đó khi được đặt hàngq

alter table sanpham add tongsl int ;

create trigger CotSoLuong
on CHITIETDONHANG
for insert,update
as
	begin
		update SanPham
		set TongSl=(select sum(a.SoLuongDat) from ChiTietDonHang a, inserted b where a.MaSP = b.MaSP ) 
		where SanPham.MaSP =(select MaSP from  inserted)
	end


b. Tạo View1 hiển thị danh sách các sản phẩm có xuất xứ từ Nhật có số lượng đặt hàng trên 2 
sản phẩm. Thông tin gồm MASP, TENSP, XUATXU, SOLUONGDAT. (1 điểm)
create view V1 as
select A.MASP, B.TENSP, XUATXU, SOLUONGDAT
from CHITIETDONHANG A,SANPHAM B
where A.MASP=B.MASP AND SOLUONGDAT > 2

SELECT * FROM V1

c. Tạo View2 hiển thị các sản phẩm chưa được đặt trong tháng 12 (năm 2011). Thông tin hiển 
thị kết quả gồm: MASP, TENSP (1 điểm)
CREATE VIEW V2 AS
SELECT B.MASP, B.TENSP
FROM DONDATHANG A, SANPHAM B,CHITIETDONHANG C
WHERE A.MADH=C.MADH AND B.MASP=C.MASP AND NGAYDH NOT IN (SELECT NGAYDH FROM DONDATHANG  WHERE MONTH(NGAYDH)=12 )

SELECT*FROM V2
d. Tạo Store Procedure có tên P1 truy vấn thống kê tổng số lượng đặt hàng của từng sản phẩm 
trong năm 2011. Thông tin hiển thị kết quả như sau: (1.5 điểm)

CREATE PROC P1 AS
	BEGIN
		SELECT MASP , SUM(SOLUONGDAT) SLDDH
		FROM CHITIETDONHANG A,DONDATHANG B
		WHERE A.MADH=B.MADH AND YEAR(NGAYDH)=2011
		GROUP BY MASP
	END

P1
e. Tạo Function F1 trả về số đơn đặt hàng của khách hàng. Tham số là MAKH, nếu khách hàng
nào chưa đặt hàng thì trả về giá trị 0. (1 điểm)

CREATE FUNCTION F1 (@MAKH VARCHAR(10))
RETURNS INT
AS
	BEGIN
		declare @tong int
		if exists (select MAKH from DONDATHANG where MAKH=@MAKH)
		set @tong = (select COUNT(MAKH) from DONDATHANG where MAKH=@MAKH)
		else
		set @tong = 0

		return @tong
	END

select SL_DDH=dbo.F1('KH01')

f. Tạo Function F2 trả về Table thống kê tổng số lượng đặt của từng sản phẩm theo từng quý.
Thông tin hiển thị gồm: MASP, TENSP, QUY, TONGSOLUONGDAT. (1.5 điểm)

CREATE FUNCTION F2 (@NAM INT )
RETURNS @HD TABLE 
(
	MASP VARCHAR(10),
	TENSP NVARCHAR(100), 
	QUY INT , 
	TONGSOLUONGDAT INT 
)
AS
	BEGIN
		insert @HD
		SELECT C.MASP, B.TENSP,QUY = DATEPART(Q,NGAYDH), TONGSOLUONGDAT=SUM(SOLUONGDAT)
		FROM  DONDATHANG A,SANPHAM B, CHITIETDONHANG C
		WHERE A.MADH=C.MADH AND B.MASP=C.MASP AND year(NGAYDH)=@nam
		GROUP BY C.MASP, B.TENSP
	RETURN 
	END

select* from dbo.F2(2011)