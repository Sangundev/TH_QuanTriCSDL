create database QL_TTBD_AmNhac
use QL_TTBD_AmNhac
set dateformat dmy

create table NHACSI(
MANS varchar(10) not null primary key ,
TENNS nvarchar(100) )

create table BAIHAT(
MABH varchar(10) not null PRIMARY key , 
TENBH nvarchar(100) ,
NAMST int, 
MANS varchar(10) default null)  

alter table BAIHAT add constraint FK_MANS foreign key(MANS)
references NHACSI(MANS);

create table CASI(
MACS varchar(10) not null primary key, 
TENCS nvarchar(100)
) 

create table THONGTINBIEUDIEN(
MABD varchar(10) not null primary key ,
MABH varchar(10) default null,
MACS varchar(10) default null, 
NGAYBD date) 

alter table THONGTINBIEUDIEN add constraint FK_MABH foreign key(MABH)
references BAIHAT(MABH);

alter table THONGTINBIEUDIEN add constraint FK_MACS foreign key(MACS)
references CASI(MACS);
---NHAP DL---
insert into NHACSI values('NS01', N'Trịnh Công Sơn')
insert into NHACSI values('NS02', N'Phạm Minh Tuấn')
insert into NHACSI values('NS03',N'Phan Huỳnh Điểu')
insert into NHACSI values('NS04',N'Thế Hiền')

insert into CASI values('CS01', N'Quang Dũng')
insert into CASI values('CS02', N'Mỹ Tâm')
insert into CASI values('CS03', N'Đàm Vĩnh Hưng')
insert into CASI values('CS04', N'Quang Lý')
insert into CASI values('CS05', N'Thanh Thúy')

insert into BAIHAT values('BH01', N'Hạ trắng',1961,'NS01' )
insert into BAIHAT values('BH02', N'Thuyền và biển',1981,'NS03' )
insert into BAIHAT values('BH03', N'Biển nhớ ',1962,'NS01' )
insert into BAIHAT values('BH04', N'Nhánh lan rừng ',1986,'NS04' )
insert into BAIHAT values('BH05', N'Đất nước',1984,'NS02' )

insert into THONGTINBIEUDIEN values('01', 'BH01','CS01','03/02/2018')
insert into THONGTINBIEUDIEN values('02', 'BH02','CS04','08/03/2018')
insert into THONGTINBIEUDIEN values('03', 'BH04','CS01','19/05/2018')
insert into THONGTINBIEUDIEN values('04', 'BH01','CS02','25/12/2018')
insert into THONGTINBIEUDIEN values('05', 'BH03','CS03','03/02/2019')
insert into THONGTINBIEUDIEN values('06', 'BH02','CS01','30/04/2019')
insert into THONGTINBIEUDIEN values('07', 'BH01','CS03','30/04/2019')
-----------SQL----------------
--a. Tạo View tên V1 tìm các bài hát sáng tác trước năm 1975 và được biểu diễn trong năm 2018. 
--Thông tin hiển thị kết quả gồm: MABH, TENBH, TENNS, NAMST. (0.5 điểm) 
 Create alter view V1 as
  Select distinct A.MABH, TENBH, TENNS, NAMST
  From BAIHAT a, NHACSI b, THONGTINBIEUDIEN c
  Where a.mans=b.mans and a.mabh=c.mabh and Namst<1975
             and   year(NgayBD)=2018

select*from V1
--b. Tạo Function tên F1 trả về số ca sĩ biểu diễn của từng ca khúc. 
--Nếu bài hát nào chưa được biểu diễn  thì trả về giá trị 0. Tham số là mã bài hát. (0.5 điểm) 
Create Function F1 (@mabh varchar(6))
Returns int
Begin
   Declare @socs int
    Set @socs= (select count(macs) from THONGTINBIEUDIEN
                          Where mabh=@mabh group by mabh)
   Return @socs
	End 
SELECT sum=DBO.F1('BH01')
--d. Tạo Procedure tên P1 thống kê tổng số ca sĩ biểu diễn từng bài hát (bài hát nào chưa biểu diễn thì  TONG=0). 
--Thông tin hiển thị gồm: MABH, TENBT, TỔNG SỐ CA SĨ (Tổng số ca sĩ được gọi từ  hàm F1) (1 điểm)
Create alter proc P1 AS
	Begin
		Select distinct b.MABH,TENBH,[TONGSOCASI] = dbo.F1(b.MABH)
		From THONGTINBIEUDIEN a left join BAIHAT b on a.Mabh=b.mabh
		group by b.MABH,TENBH
	End 

P1
--e. Tạo TRIGGER tên T1 thực hiện yêu cầu sau: (0.5 điểm) 
--- Mỗi bài hát không được biểu diễn quá 3 lần trong 1 ngày. 
Create trigger T1 on THONGTINBIEUDIEN
For insert, update
As
  Begin
      If (select count(*) from inserted a, THONGTINBIEUDIEN  b
           Where a.mabh=b.mabh and a.ngaybd=b.ngaybd)>3
         Begin
             Print N'Bao loi'
             ROLLBACK TRANSACTION
         end
  End 