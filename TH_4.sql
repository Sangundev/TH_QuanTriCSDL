create database QL_SANPHAM
USE QL_SANPHAM


CREATE TABLE LOAISP (
MaLoai VARCHAR(10) NOT NULL PRIMARY KEY,
TenLoai NVARCHAR(100) )

CREATE TABLE SANPHAM (
MASP VARCHAR(10) NOT NULL, 
TenSP NVARCHAR(100),
Mota NVARCHAR(100), 
Gia INT,
Maloai VARCHAR(10) NOT NULL
PRIMARY KEY (MASP,Maloai ))

ALTER TABLE SANPHAM
ADD CONSTRAINT FK_SANPHAM_LOAISP FOREIGN KEY(Maloai)
    REFERENCES LOAISP(Maloai)

CREATE TABLE KHACHHANG (
MAKH VARCHAR(10) NOT NULL PRIMARY KEY,
TenKH NVARCHAR(100),
DC NVARCHAR(100), 
DT CHAR(15))

CREATE TABLE DONDH (SoDDH, NgayDat, MAKH)
CREATE TABLE CTDDH (SoDDH, MASP, SoLuong)
CREATE TABLE NGUYENLIEU (MaNL, TenNL, DVT, Gia)
CREATE TABLE LAM (MaNL, MASP, SoLuong)