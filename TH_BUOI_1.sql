
use QLBH
--1.	Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW CAU1 AS
SELECT*
FROM KHACHHANG
WHERE DIACHI=N'TÂN BÌNH'

SELECT*FROM CAU1
--2.	Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng, địa chỉ và địa 
--chỉ E-mail của những khách hàng chưa có số điện t
CREATE VIEW CAU2 AS
SELECT*
FROM KHACHHANG
WHERE DT IS NULL

SELECT*FROM CAU2
--3.	Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ 
----Email gồm mã khách hàng, tên khách hàng, địa chỉ.
CREATE VIEW CAU3 AS
SELECT*
FROM KHACHHANG
WHERE DT IS NULL AND DIACHI IS NULL AND EMAIL IS NULL

SELECT*FROM CAU3

--4.Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail 
---gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW CAU4 AS
SELECT*
FROM KHACHHANG
WHERE DT not in ('NULL') AND EMAIL not in ('NULL')

SELECT*FROM CAU4
--5.	Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá mua.
CREATE VIEW CAU5 AS
SELECT*
FROM VATTU
WHERE DVT =N'Cái'

SELECT*FROM CAU5

--6.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, 
---đơn vị tính và giá mua mà có giá mua trên 25000.
CREATE VIEW CAU6 AS
SELECT*
FROM VATTU
WHERE giamua >25000

SELECT*FROM CAU6

--7.	Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch)
---gồm mã vật tư, tên vật tư, đơn vị tính và giá mua
CREATE VIEW CAU7 AS
SELECT*
FROM VATTU
WHERE tenvt LIKE (N'%GẠCH%')

SELECT*FROM CAU7
--8.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, 
--đơn vị tính và giá mua mà có giá mua nằm trong khoảng từ 20000 đến 40000.

CREATE VIEW CAU8 AS
SELECT*
FROM VATTU
WHERE 20000<GIAMUA and giamua<40000

SELECT*FROM CAU8
--9.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng,
----địa chỉ khách hàng và số điện thoại.
CREATE VIEW CAU9 AS
SELECT*
FROM HOADON

SELECT*FROM CAU9
---10.	Lấy ra các thông tin gồm Mã hóa đơn, tên khách hàng,
----địa chỉ khách hàng và số điện thoại của ngày 25/5/2010.

CREATE VIEW CAU10 AS
SELECT*
FROM hoadon
WHERE day(ngay)=25 and month(ngay)=5 and year(ngay)=2010

SELECT*FROM CAU10

--11.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng
---, địa chỉ khách hàng và số điện thoại của những hóa đơn trong tháng 6/2010.
CREATE VIEW CAU11 AS
SELECT*
FROM hoadon
WHERE month(ngay)=6 and year(ngay)=2010

SELECT*FROM CAU11
--12.	Lấy ra danh sách những khách hàng (tên khách hàng, địa chỉ, số điện thoại)
--đã mua hàng trong tháng 6/2010.
CREATE VIEW CAU12 AS
SELECT*
FROM hoadon
WHERE month(ngay)=6 and year(ngay)=2010

SELECT*FROM CAU12
--13.	Lấy ra danh sách những khách hàng không mua hàng trong tháng 6/2010 gồm
---các thông tin tên khách hàng, địa chỉ, số điện thoại.
CREATE VIEW CAU13 AS
SELECT*
FROM hoadon
WHERE month(ngay) !=6 and year(ngay)=2010

SELECT*FROM CAU13
--14.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư,
--đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng).
CREATE
alter VIEW CAU14 AS
SELECT b.DVT,a.giaban,b.giamua,a.sl,sum(a.giaban*sl) gtban , sum(b.giamua*sl) gtmua
FROM CTHD a,VATTU b
WHERE a.mavt=b.mavt 
group by  b.DVT,a.giaban,b.giamua,a.sl

SELECT*FROM CAU14
--15.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn,
--mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng,
--trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) 
--mà có giá bán lớn hơn hoặc bằng giá mua.
CREATE VIEW CAU15 AS
SELECT b.DVT,a.giaban,b.giamua,a.sl,trigiamua=giamua*sl,trigiaban=giaban*sl
FROM CTHD a,VATTU b
WHERE a.mavt=b.mavt and giaban > giamua

SELECT*FROM CAU15

--16.	Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, 
---số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) và 
-----cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn lớn hơn 100.

create view cau16 as
select a.mavt,tenvt,dvt,giaban,giamua,sl,trigiamua=giamua*sl,trigiaban=sl*giaban,
khuyenmai=iif(sl>100,0.1*sl*giaban,0)
from vattu a ,cthd b
where a.mavt=b.mavt 

select * from cau16

--17.	Tìm ra những mặt hàng chưa bán được.
create view cau17 as
select *from vattu
where mavt not in (select distinct mavt from cthd)

select *from cau17
--18.	Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư,
--đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán
select a.mahd,tenkh,ngay,diachi,dt,tenvt,dvt,giamua,giaban,sl,trigiamua=sl*giamua,trigiaban=sl*giaban
INTO BANGTONGHOP
from hoadon a ,khachhang b,vattu c ,cthd d
where a.makh=b.makh and a.mahd=d.mahd and c.mavt=d.mavt

--19.	Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin:
--mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, 
---số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
create view CAU19 AS
select b.dt,c.tenvt,c.dvt,c.giamua,d.sl,d.giaban,sum(d.giaban*sl) gtban , sum(c.giamua*sl) gtmua
from hoadon a ,khachhang b,vattu c ,cthd d
where a.makh=b.makh and a.mahd=d.mahd and c.mavt=d.mavt
group by b.dt,c.tenvt,c.dvt,c.giamua,d.sl,d.giaban

select*from cau19

20.	Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
21.	Lấy ra danh sách các hóa đơn gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
22.	Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
23.	Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
--24.	Đếm xem mỗi khách hàng có bao nhiêu hóa đơn.
select a.tenkh ,count(b.makh) sohd
from khachhang a, hoadon b
where a.makh=b.makh
group by a.tenkh
25.	Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.
26.	Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.
--27.	Lấy ra các thông tin của khách hàng có số lượng hàng
--mua nhiều nhất.
select top 1 with ties a.tenkh ,count(b.makh) slmua
from khachhang a, hoadon b
where a.makh=b.makh
group by a.tenkh
order by sohd desc
--28.	Lấy ra các thông tin về các mặt hàng mà được 
--bán trong nhiều hóa đơn nhất.
select top 1 with ties a.tenvt ,count(b.mavt) hehe
from vattu a, cthd b
where a.mavt=b.mavt
group by a.tenvt
order by hehe desc
--29.	Lấy ra các thông tin về các mặt hàng mà
--được bán nhiều nhất

select top 1 with ties a.tenvt ,sum(b.sl) haha
from vattu a, cthd b
where a.mavt=b.mavt
group by a.tenvt
order by haha desc

--30.Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, 
--tên khách hàng, địa chỉ, số lượng hóa đơn đã mua 
--(nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn để trống)

////////////////////////// proc
1.	Lấy ra danh các khách hàng đã mua hàng trong ngày X, với X là tham số truyền vào.
CREATE ALTER PROC P1(@X DATE)
AS
	BEGIN
	if EXISTS(SELECT NGAY FROM HOADON WHERE NGAY=@X)
		SELECT A.MAKH,TENKH,MAHD,NGAY
		FROM KHACHHANG A,HOADON B
		WHERE A.MAKH=B.MAKH AND NGAY=@X
	ELSE
		PRINT N'KGONG TIM THAY '
	END
--GỌI THỦ TỤC
TÊN THỦ TỤC GIÁ TRỊ THAM SỐ 

SET DATEFORMAT DMY 

P1 '26/05/2020'
2.	Lấy ra danh sách khách hàng có tổng trị giá các đơn hàng lớn hơn X (X là tham số).
CREATE PROC P2(@X FLOAT) 
AS
	BEGIN
		SELECT A.MAKH,TENKH,TONGGIATRIMUA=SUM(SL*GIABAN)
		FROM KHACHHANG A,HOADON B,CTHD C
		WHERE A.MAKH=B.MAKH AND B.MAHD=C.MAHD
		GROUP BY A.MAKH,TENKH
		HAVING SUM(SL*GIABAN)>@X
	END

P2 5000000

3.	Lấy ra danh sách X khách hàng có tổng trị giá các đơn hàng lớn nhất (X là tham số).
CREATE 
ALTER PROC P3(@X int) 
AS
	BEGIN
		SELECT TOP (@X) WITH TIES A.MAKH,TENKH,TONG_GT_MUA=SUM(SL*GIABAN)
		FROM KHACHHANG A,HOADON B,CTHD C
		WHERE A.MAKH=B.MAKH AND B.MAHD=C.MAHD
		GROUP BY A.MAKH,TENKH
		ORDER BY TONG_GT_MUA DESC 
	END
P3 '2'
4.	Lấy ra danh sách X mặt hàng có số lượng bán lớn nhất (X là tham số).

CREATE PROC P4(@X int) 
AS
	BEGIN
		SELECT TOP (@X) WITH TIES A.mavt,tenvt,TONG_GT_ban=sum(SL)
		FROM vattu A,HOADON B,CTHD C
		WHERE A.MAVT=C.MAVT AND B.MAHD=C.MAHD
		GROUP BY A.mavt,tenvt
		ORDER BY TONG_GT_ban DESC 
	END
P4 '2'

5.	Lấy ra danh sách X mặt hàng bán ra có lãi ít nhất (X là tham số).
CREATE PROC P5(@X int) 
AS
	BEGIN
		SELECT TOP (@X) WITH TIES A.mavt,tenvt,LAI_IT=(C.GIABAN-A.GIAMUA)*SL
		FROM vattu A,HOADON B,CTHD C
		WHERE A.MAVT=C.MAVT AND B.MAHD=C.MAHD
		ORDER BY LAI_IT 
	END
P5 '2'
6.	Lấy ra danh sách X đơn hàng có tổng trị giá lớn nhất (X là tham số).
CREATE PROC P6(@X int) 
AS
	BEGIN
		SELECT TOP (@X) WITH TIES A.mavt,tenvt,TONGTG=sum(GIABAN*SL)
		FROM vattu A,HOADON B,CTHD C
		WHERE A.MAVT=C.MAVT AND B.MAHD=C.MAHD
		group by  A.mavt,tenvt
		ORDER BY TONGTG DESC
	END
P6 '2'
7.	Tính giá trị cho cột khuyến mãi như sau: Khuyến mãi 5% nếu SL > 100, 10% nếu SL > 500.

CREATE
ALTER PROC P7 
AS
	BEGIN
		update CTHD
		SET khuyenmai=iif(sl>500,0.1*sl*giaban,iif(SL>100,0.05*sl*giaban,0))
	END

P7 

8.	Tính lại số lượng tồn cho tất cả các mặt hàng (SLTON = SLTON – tổng SL bán được).
CREATE
ALTER PROC P8
AS
	BEGIN
		update VATTU
		SET SLTON=SLTON-(SELECT SUM(SL) FROM CTHD WHERE CTHD.MAVT=VATTU.MAVT)
	END
P8

9.	Tính trị giá cho mỗi hóa đơn.SL*GIABAN

CREATE PROC P9
AS
	BEGIN
		update HOADON
		SET TONGTG= (SELECT SUM(SL*GIABAN) FROM CTHD WHERE CTHD.MAHD=HOADON.MAHD)
	END
P9

10.	Tạo ra table KH_VIP có cấu trúc giống với cấu trúc table KHACHHANG.
Lưu các khách hàng có tổng trị giá của tất cả các đơn hàng >=10,000,000 vào table KH_VIP.
CREATE PROC P10 
AS
	BEGIN
		select A.MAKH,tenkh,diachi,dt,EMAIL
		INTO KH_VIP
		from khachhang A, cthd B , hoadon C
		where A.makh=C.makh and C.mahd=B.mahd
		GROUP BY A.MAKH,tenkh,diachi,dt,EMAIL
		having sum(sl*giaban) >= 10000000
	END
///------------------------------------------------------------------------
 funtion

 create function F1(@TS INT)




 1.	Viết hàm tính doanh thu của năm, với năm là tham số truyền vào.

 create function F1(@NAM INT)
 RETURNS NUMERIC(10,0)
 AS
	BEGIN
		----KHAI BAO BIEN NHAN GT TRA VE 
		declare @DANHTHU NUMERIC(10,0)

		if exists (select year(ngay) from hoadon where year(ngay) = @NAM)
			SET @DANHTHU=(SELECT SUM(SL*GIABAN) FROM HOADON A, CTHD B
							WHERE A.MAHD=B.MAHD AND YEAR(NGAY)=@NAM )
		ELSE 
			SET @DANHTHU=0
---TRA VE GIA TRI 
		RETURN @DANHTHU
	END

---GOI HAM 
PRINT DBO.F1(2010)
SELECT DANHTHU=DBO.F1(2010)
2.	Viết hàm tính doanh thu của tháng, năm, với tháng và năm là 2 tham số truyền vào.

CREATE
alter FUNCTION F2 (@THANG INT , @NAM INT)
RETURNS NUMERIC(10,0)
AS
	BEGIN
		declare @DANHTHU NUMERIC(10,0)
		if exists (select MONTH(NGAY),year(ngay) from hoadon where year(ngay) = @NAM AND MONTH(NGAY)= @THANG)
			SET @DANHTHU=(SELECT SUM(SL*GIABAN) FROM HOADON A, CTHD B
							WHERE A.MAHD=B.MAHD AND YEAR(NGAY)=@NAM AND MONTH(NGAY)= @THANG )
	ELSE 
			SET @DANHTHU=0
---TRA VE GIA TRI 
		RETURN @DANHTHU
	END

SELECT DANHTHU=DBO.F2(6,2010)
3.	Viết hàm tính doanh thu của khách hàng với mã khách hàng là tham số truyền vào.
 create function F3(@MAKH varchar(10))
 RETURNS NUMERIC(10,0)
 AS
	BEGIN
		----KHAI BAO BIEN NHAN GT TRA VE 
		declare @DANHTHU NUMERIC(10,0)

		if exists (select makh from khachhang where makh = @MAKH)
			SET @DANHTHU=(SELECT SUM(SL*GIABAN) FROM HOADON A, CTHD B
							WHERE A.MAHD=B.MAHD AND A.MAKH=@MAKH )
		ELSE 
			SET @DANHTHU=0
---TRA VE GIA TRI 
		RETURN @DANHTHU
	END

SELECT DANHTHU=DBO.F3('KH02')
4.	Viết hàm tính tổng số lượng bán được cho từng mặt hàng theo tháng, năm nào đó. Với mã hàng, tháng và năm là các tham số truyền vào, 
nếu tháng không nhập vào tức là tính tất cả các tháng.
 create function F4(@MAVT varchar(10), @THANG INT , @NAM INT)
 RETURNS INT 
 AS
	BEGIN
		declare @TONGSL INT
			IF(@THANG IS NULL)
			SET @TONGSL=(SELECT SUM(SL)
							FROM HOADON A,CTHD B
							WHERE A.MAHD=B.MAHD AND YEAR(NGAY)=@NAM AND MAVT = @MAVT)
			ELSE 
			SET @TONGSL=(SELECT SUM(SL)
							FROM HOADON A,CTHD B
							WHERE A.MAHD=B.MAHD AND YEAR(NGAY)=@NAM AND MAVT = @MAVT AND YEAR(NGAY)=@THANG)
---TRA VE GIA TRI 
		RETURN @TONGSL
	END

SELECT TSL=DBO.F4('VT01',5,2010)
5.	Viết hàm tính lãi (giá bán – giá mua) * số lượng bán được cho từng mặt hàng,
với mã mặt hàng là tham số truyền vào. Nếu mã mặt hàng không truyền vào thì tính cho tất cả các mặt hàng.

CREATE FUNCTION F5 (@MAVT VARCHAR(7))
returns INT
as
	begin 
		declare @LAI INT
		if(@MAVT IS NULL)
		SET @LAI=(SELECT (GIABAN-GIAMUA)*SL FROM VATTU A,CTHD B
				WHERE A.MAVT=B.MAVT )
		ELSE
			SET @LAI=(SELECT (GIABAN-GIAMUA)*SL FROM VATTU A,CTHD B
				WHERE A.MAVT=B.MAVT AND B.MAVT=@MAVT)

		RETURN @LAI
	end 

SELECT LS=DBO.F5(NULL)

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
CREATE TRIGGER TRG02
ON KHACHHANG
FOR DELETE
AS
	BEGIN
		DECLARE @MAKH CHAR(10)
		SET @MAKH=(SELECT MAKH FROM deleted)

		IF EXISTS(SELECT MAKH FROM HOADON WHERE MAKH=@MAKH)
			BEGIN
				RAISERROR(N'KHÔNG XOÁ ĐƯỢC VÌ KHÁCH HÀNG ĐÃ CÓ HOÁ ĐƠN',16,1)
				ROLLBACK TRANSACTION
			END
		ELSE
			PRINT N'XOÁ THÀNH CÔNG'
	END

DELETE FROM KHACHHANG WHERE MAKH='KH06'
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
CREATE TRIGGER TRG05
ON CTHD
FOR INSERT,UPDATE
AS
	BEGIN
		DECLARE @MAVT CHAR(10),@SLBAN INT
		SELECT @MAVT=MAVT,@SLBAN=SL FROM inserted 

		IF (@SLBAN >(SELECT SLTON FROM VATTU WHERE MAVT=@MAVT))
			BEGIN
				RAISERROR(N'TRONG KHO KHÔNG ĐỦ HÀNG',16,1)
				ROLLBACK TRANSACTION
			END
		ELSE
			UPDATE VATTU
			SET SLTON=SLTON-@SLBAN
			WHERE MAVT=@MAVT
	END


--6.Không cho phép user xóa một lúc nhiều hơn một vật tư.

--7.Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.
--8.Mỗi hóa đơn có tổng trị giá tối đa 50000000.
--9.Không được phép bán hàng lỗ quá 50%.
--10.Chỉ bán mặt hàng Gạch (các loại gạch) với số lượng là bội số của 100.
