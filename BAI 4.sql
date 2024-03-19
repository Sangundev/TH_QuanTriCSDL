create database QL_san_Pham
go 
use QL_san_Pham
go
create table LOAISP (
MaLoai char(10) not null primary key ,
TenLoai nvarchar(100) )

create table SANPHAM (
MASP char(10) not null primary key,
TenSP nvarchar(100) , 
Mota char(10) not null ,
Gia int , 
Maloai char(10) default null)

alter table SANPHAM add constraint FK_Maloai foreign key(Maloai)
references LOAISP(Maloai);

create table KHACHHANG (
MAKH char(10) not null primary key,
TenKH nvarchar(100),
DC nvarchar(100),
DT char(15) )

create table DONDH (
SoDDH char(10) not null primary key, 
NgayDat date,
MAKH char(10) default null)

alter table DONDH add constraint FK_MAKH  foreign key(MAKH )
references KHACHHANG(MAKH );

create table CTDDH (
SoDDH char(10) not null, 
MASP char(10) not null,
SoLuong int 
primary key(SoDDH,MASP))

alter table CTDDH add constraint FK_CT_MASP  foreign key(MASP )
references SANPHAM(MASP);
alter table CTDDH add constraint FK_CT_SoDDH  foreign key(SoDDH )
references DONDH(SoDDH);

create table NGUYENLIEU (
MaNL char(10) not null primary key,
TenNL nvarchar(100),
DVT nvarchar(100), 
Gia int )

create table LAM (
MaNL char(10) not null, 
MASP char(10) not null, 
SoLuong int 
primary key(MaNL,MASP))

alter table LAM  add constraint FK_LAM_MASP  foreign key(MASP)
references SANPHAM(MASP);
alter table LAM  add constraint FK_LAM_MaNL  foreign key(MaNL)
references NGUYENLIEU(MaNL);

-----------------------SQL------------------------------\

