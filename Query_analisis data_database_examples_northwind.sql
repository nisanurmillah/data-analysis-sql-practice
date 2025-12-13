---TASK 1
  ---JOIN TABEL CUSTOMER, ORDER, ORDER DETAIL, DAN product_id
SELECT * 
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails d ON d.order_id = o.order_id
JOIN products p ON p.product_id = d.product_id;

--karyawan yang lulusan psychologi
SELECT e. employee_id, e. first_name, e. last_name 
FROM employees e
WHERE notes LIKE '%psychology%'

-- jumlah customer dari london dan jerman
SELECT COUNT(c. customer_id) FROM customers c
WHERE c.country IN ('Germany','London');

--List order berupa order_id, tanggal_order, nama produk, na customer, nama pengirim
SELECT o.order_id, o.order_date, p.product_name, c.customer_name, s.shipper_name
FROM shippers s
JOIN orders o ON o.shipper_id = s.shipper_id
JOIN customers c ON c.customer_id = o.customer_id
JOIN orderdetails d ON d.order_id = o.order_id
JOIN products p ON p.product_id = d.product_id;

---jumlah order kategori seafood yang terjual
SELECT SUM(d.quantity) AS jumlah_seafood_yang_terjual, COUNT(d.order_detail_id) AS jumlah_order
FROM order_details d 
JOIN products p ON p.product_id=d.product_id
JOIN categories r ON p.category_id=r.category_id
WHERE r.category_name LIKE '%Meat%';

--produk dari USA dan JAPAN
SELECT p.product_id, p.product_name, s.supplier_name
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE s.country IN ('USA', 'Japan');

-----siapa yang melakukan pembayaran yang paling tinggi?
SELECT c.customer_id, c.customer_name, p.product_name, SUM(d.quantity*p.price) AS total_amount
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name, p.product_name
ORDER BY total_amount DESC;

--Tambahkan data customer penjualan
INSERT INTO customers VALUES ('93','zaki','muhammad','bayongbong','garut','09768543','indonesia');
INSERT INTO orders VALUES('10451','93','2','1998-11-06','2');
INSERT INTO orderdetails VALUES('520','10451','74','5');

--tambahkan data customer penjualan
INSERT INTO customers VALUES ('94','rara','zakiya','karang_pawitan', 'garut','08976543', 'indonesia');
INSERT INTO orders VALUES ('10452', '94', '3','2008-12-08', '2');
INSERT INTO orderdetails VALUES ('521','10452','77','8');

---Siapa yang membayar paling tinggi dan apa saja produk yang dibeli (gabungin product dalam satu baris pakai STRING_AGG(...,..))
SELECT c.customer_id, c.customer_name, SUM(d.quantity*p.price) AS total_amount, STRING_AGG(p.product_name,',') AS nama_produk
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

--Siapa yang melakukan pembayaran paling tinggi
SELECT c.customer_id, c.customer_name, SUM(d.quantity*p.price) AS total_amount, STRING_AGG(p.product_name,',') AS nama_produk_yang_dibeli
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

----sertakan dengan jumlah produk yang dibelinya
SELECT 
  c.customer_id,
  c.customer_name,
  SUM(d.quantity * p.price) AS total_amount,
  STRING_AGG(p.product_name || ' (' || d.quantity || ')' , ', ') AS produk_yang_dibeli
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails d ON o.order_id = d.order_id
JOIN products p ON d.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

-- sertakan harga, jumlah beli, dan total bayarnya
SELECT c.customer_id, c.customer_name, p.product_name, d.quantity, p.price, SUM(p.price*d.quantity) AS total_bayar
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
WHERE c.customer_id='20'
GROUP BY c.customer_id, c.customer_name, p.product_name, d.quantity, p.price
ORDER BY total_bayar DESC;

-----produk yang penjualannya paling tinggi dan siapa saja customer yang membelinya?
SELECT 
  p.product_id,
  p.product_name,
  SUM(d.quantity) AS total_quantity_sold,
  STRING_AGG(c.customer_name,',') AS nama_customer
FROM products p
LEFT JOIN orderdetails d ON p.product_id = d.product_id
JOIN orders o ON o.order_id=d.order_id
JOIN customers c ON c.customer_id=o.customer_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;

--Berapa persentase penjualan per produknya dibandingkan total keseluruhannya? 
SELECT 
  p.product_id, p.product_name, 
  SUM(d.quantity) AS total_terjual,
    (SELECT SUM(d.quantity) FROM orderdetails d) AS total_semuanya,
  SUM(d.quantity)::numeric/(SELECT SUM(d.quantity) FROM orderdetails d)::numeric*100 AS persentase_penjualan
FROM products p
JOIN orderdetails d ON p.product_id = d.product_id
GROUP BY p.product_id, p.product_name
ORDER BY persentase_penjualan DESC;

--Siapa supplier dari produk yang memiliki persentase perjualan tertinggi itu?
SELECT s. supplier_id, s.supplier_name, p.product_name
FROM suppliers s
JOIN products p ON p.supplier_id=s.supplier_id
WHERE p.product_name= 'Gorgonzola Telino';

--Apa saja produk yang di supply supplier tersebut
SELECT p.product_id, p.product_name, p.unit, p.price, s.supplier_name
FROM products p
JOIN suppliers s ON s.supplier_id=p.supplier_id
WHERE supplier_name LIKE '%Formaggi Fortini%'
ORDER BY p.price DESC;

SELECT p.product_id, p.product_name, d.quantity, p.unit
FROM products p  
JOIN orderdetails d ON p.product_id=d.product_id
WHERE p.product_name LIKE '%Gula%';

-- Siapa saja customer yang berasal dari London, Berlin, Garut 
SELECT c.customer_name, c.city FROM customers c WHERE c.city='London' OR c.city='Berlin' OR c.city='garut';

SELECT p.product_id, p.product_name, p.price
FROM products p
ORDER BY p.price DESC;

-- data produk yang dibeli berdasarkan karyawan
SELECT c.customer_id, c.customer_name, SUM(d.quantity*p.price) AS total_amount, STRING_AGG(p.product_name,',') AS nama_produk_yang_dibeli
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM orderdetails LIMIT 10;
SELECT * FROM products LIMIT 10;

-- siapa customer yang memiliki pembelian tertinggi
SELECT 
  c.customer_id,
  c.customer_name,
  SUM(d.quantity * p.price) AS total_amount,
  STRING_AGG(p.product_name || ' (' || d.quantity || ')' , ', ') AS produk_yang_dibeli
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails d ON o.order_id = d.order_id
JOIN products p ON d.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

---Apa saja yang dibeli oleh customer tersebut 
SELECT c.customer_id, c.customer_name, p.product_name, d.quantity, p.price, SUM(p.price*d.quantity) AS total_bayar
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
WHERE c.customer_id='20'
GROUP BY c.customer_id, c.customer_name, p.product_name, d.quantity, p.price
ORDER BY total_bayar DESC;

-----produk apa yang paling diminati, atau persentase perjualannya paling tinggi?
---COALESCE=tampilkan hasil kalo f(x)=hasil, kalau tidak ada hasil isi nol--> COALESCE(f(x),0)
SELECT 
  p.product_id,
  p.product_name,
  COALESCE(SUM(d.quantity),0) AS total_quantity_sold
FROM products p
LEFT JOIN orderdetails d ON p.product_id = d.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;

---Berrapa persentase penjualannya
SELECT
p.product_id,
p.product_name,
COALESCE(SUM(p.price*d.quantity),0) AS total_terjual,-----COALESCE(kosong,0) artinya kalo si f(x)=kosong, isi aja nol
(SUM(d.quantity)*p.price) AS total_semua,
ROUND(
  COALESCE(SUM(p.price*d.quantity),0)/
  NULLIF((SUM(d.quantity)*p.price),0)*100,2---NULLIF(angka1,angka2), NUlLIF (f(x)=0),0) isi aja 'NULL' kalo f(x)=0 untuk mencegah pembagian dgn 0, 
  ) AS persentase
FROM products p
JOIN orderdetails d ON d.product_id=p.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY persentase DESC;


---ini pake subquery untuk bandingin sama toal semua
SELECT
  p.product_id,
  p.product_name,
  COALESCE(SUM(p.price * d.quantity), 0) AS total_terjual,
  ROUND(                              -------------ROUND= untuk memfilter desimalnya berapa ROUND(angka, jumlah desimal)
    COALESCE(SUM(p.price * d.quantity), 0) /------COALESCE (hasil,0)
    (
      SELECT SUM(p2.price * d2.quantity)
      FROM products p2
      JOIN orderdetails d2 ON d2.product_id = p2.product_id
    ) * 100,
    2
  ) AS persentase
FROM products p
JOIN orderdetails d ON d.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY persentase DESC;

-----ini versi sederhananya
SELECT 
  p.product_id,
  p.product_name,
  SUM(d.quantity) AS total_sold,
  (SELECT SUM(quantity) FROM orderdetails) AS total_all_sold---- dihitung total semuanya tanpa filter
FROM products p
LEFT JOIN orderdetails d ON p.product_id = d.product_id
GROUP BY p.product_id, p.product_name;

INSERT INTO customers VALUES ('92','nisa','millah','bayongbong','garut','09768543','indonesia');
INSERT INTO orders VALUES('10450','92','2','1999-11-06','2');
INSERT INTO orderdetails VALUES('519','10450','74','5');

--Menghitung suplier terbesar
SELECT s.supplier_id, s.supplier_name, STRING_AGG(p.product_name,',') AS jenis_produk, 
COUNT(p.product_name) AS total_product, SUM(p.price*d.quantity) AS total_dana
FROM suppliers s
JOIN products p ON p.supplier_id=s.supplier_id
JOIN orderdetails d ON d.product_id=p.product_id
GROUP by s.supplier_id, s.supplier_name
ORDER by total_product DESC;

---WITH ... AS(..)BUAT TABEL BAYANGAN
WITH supplier_revenue AS (
  SELECT s.supplier_id,
         s.supplier_name,
         SUM(p.price * d.quantity) AS total_dana_supplier
  FROM suppliers s
  JOIN products p ON p.supplier_id = s.supplier_id
  JOIN orderdetails d ON d.product_id = p.product_id
  GROUP BY s.supplier_id, s.supplier_name
),
product_revenue AS (
  SELECT s.supplier_id,
         s.supplier_name,
         p.product_name,
         SUM(p.price * d.quantity) AS total_dana_produk
  FROM suppliers s
  JOIN products p ON p.supplier_id = s.supplier_id
  JOIN orderdetails d ON d.product_id = p.product_id
  GROUP BY s.supplier_id, s.supplier_name, p.product_name
)
SELECT pr.supplier_id,
       pr.supplier_name,
       pr.product_name,
       pr.total_dana_produk,
       sr.total_dana_supplier,
       ROUND((pr.total_dana_produk::numeric / sr.total_dana_supplier) * 100, 2) AS persentase_kontribusi
FROM product_revenue pr
JOIN supplier_revenue sr ON pr.supplier_id = sr.supplier_id
ORDER BY pr.supplier_id, persentase_kontribusi DESC;

---cara langsung
SELECT s.supplier_id, 
       s.supplier_name, 
       p.product_name, 
       SUM(p.price * d.quantity) AS total_dana_produk,
       (
         SELECT SUM(p2.price * d2.quantity)
         FROM products p2
         JOIN orderdetails d2 ON d2.product_id = p2.product_id
         WHERE p2.supplier_id = s.supplier_id
       ) AS total_dana_supplier,
       ROUND( 
         SUM(p.price * d.quantity)
         /
         (
           SELECT SUM(p2.price * d2.quantity)
           FROM products p2
           JOIN orderdetails d2 ON d2.product_id = p2.product_id
           WHERE p2.supplier_id = s.supplier_id
         )
         * 100, 2
       ) AS persentase_kontribusi
FROM suppliers s
JOIN products p ON p.supplier_id = s.supplier_id
JOIN orderdetails d ON d.product_id = p.product_id
GROUP BY s.supplier_id, s.supplier_name, p.product_name
ORDER BY s.supplier_id, persentase_kontribusi DESC;

--KONSEP UTAMA
SELECT s.supplier_id,
       (
         SELECT COUNT(*) 
         FROM products p2 
         WHERE p2.supplier_id = s.supplier_id
       ) AS jumlah_produk
FROM suppliers s;


--1. Ubah nama negara pada tabel country Brazil=Indonesia
UPDATE customers c SET country='Indonesia' WHERE country='Brazil';

--2. Hapus data order dan order_details pada tahun 1997
----a. Pake DELETE FROM...WHERE..IN()
DELETE FROM order_details d WHERE d.order_id IN(SELECT o.order_id FROM orders o WHERE EXTRACT (YEAR FROM O.order_date)=1997);

----b. pake DELETE FROM...USING
        DELETE FROM order_details d 
        USING orders o
        WHERE d.order_id = o.order_id
          AND EXTRACT(YEAR FROM o.order_date) = 1997;

  --misal hapus data order dan order detail yang kategori produknya seafood, tahun ordernya 1997, dan customer dari  negara japan
      --a. Pake DELETE FROM...USING...WHERE
          DELETE FROM order_details d 
          USING orders o 
          JOIN customers c ON o.customer_id=c.customer_id
          JOIN products p ON d.product_id=p.product_id
          JOIN categories s ON p.category_id=s.category_id
          WHERE d.order_id=o.order_id
          AND EXTRACT(YEAR FROM o.order_date)=1997
          AND s.category_name='Seafood'
          AND c.country='Japan';
          
      --b. pake DELETE FROM...WHERE..IN()
          DELETE FROM order_details
          WHERE order_id IN (
          SELECT o.order_id
          FROM orders o
          JOIN customers c ON o.customer_id = c.customer_id
          JOIN order_details d ON o.order_id = d.order_id
          JOIN products p ON d.product_id = p.product_id
          JOIN categories s ON p.category_id = s.category_id
          WHERE EXTRACT(YEAR FROM o.order_date) = 1997
            AND c.country = 'Japan'
            AND s.category_name = 'Seafood');

--3.Ubah struktur type column categoryname jadi varchar 100 pada tabel actegories
ALTER TABLE categories
ALTER COLUMN category_name TYPE VARCHAR(100);

--4. Ubah nama produk jadi "makanan dari laut" untuk semua produk dengan kategori seafood
  -- a. UPDATE..FROM
        UPDATE products p 
        SET product_name='makanan dari laut' 
        FROM categories c 
        WHERE p.category_id=c.category_id 
        AND category_name='Seafood';

   --b. PAKE IN
        UPDATE products p SET product_name='makanan dari laut' WHERE p.category_id IN(SELECT c.category_id FROM categories c WHERE category_name='Seafood');
-- contoh lanjutan
-- ubah nama produk yang kategorinya seafood dan suppliernya dari negara jepang dengan nama produk best seller

      --a.pake UPDATE..FROM
        UPDATE products p
        SET product_name = 'Best Seller'
        FROM categories c, suppliers s
        WHERE p.category_id = c.category_id
          AND p.supplier_id = s.supplier_id
          AND c.category_name = 'Seafood'
          AND s.country = 'Jepang';

     --b.pake IN
        UPDATE products p
        SET product_name = 'best seller'
        WHERE p.category_id IN (
            SELECT c.category_id
            FROM categories c
            WHERE c.category_name = 'Seafood')
        AND p.supplier_id IN (
            SELECT s.supplier_id
            FROM suppliers s
            WHERE  s.country = 'Jepang');
            
     --c. pake exists
        UPDATE products p SET p.product_name = 'Best Seller' 
        WHERE EXISTS (                                      ---hanya ubah kalo ada kondisi yan cocok
                      SELECT 1
                      FROM categories c
                      JOIN suppliers s ON s.supplier_id = p.supplier_id
                      WHERE c.category_id = p.category_id
                      AND c.category_name = 'Seafood'
                      AND s.country = 'Jepang')

--cara 3 pake using
UPDATE products p
SET product_name = 'best seller'
FROM categories c, suppliers s
WHERE p.category_id = c.category_id
  AND p.supplier_id = s.supplier_id
  AND c.category_name = 'Seafood'
  AND s.country = 'Jepang';

--berapa harga yang harus dijual pembeli jika ingin mendapat keuntungan 25% dari harga modal produk yang terjual
SELECT p.product_name, p.unit, p.price, ((p.price/substring(p.unit FROM '^\d+')::numeric)*1.25) AS harga_per_satuan FROM products p GROUP BY p.product_name, p.unit, p.price ORDER BY harga_per_satuan DESC;

--berapa pendapatan yang akan didapatkan jika product yang dibeli customer terjual semua dengan harga jual mengambil keuntungan 25%
SELECT p.product_name, p.unit, p.price, ((p.price/substring(p.unit FROM '^\d+')::numeric)*1.50) AS harga_per_satuan,
(((p.price/substring(p.unit FROM '^\d+')::numeric)*1.50) * substring (p.unit FROM '^\d+')::numeric) AS pendapatan_kotor
FROM products p GROUP BY p.product_name, p.unit, p.price ORDER BY pendapatan_kotor DESC;

SELECT 
  c.customer_name, COUNT(cat.category_id) AS jumlah_kategori
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(cat.category_id) > 3;

SELECT customer_name
FROM customers c
WHERE (
  SELECT COUNT(DISTINCT p.category_id)
  FROM orders o
  JOIN orderdetails od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id
  WHERE o.customer_id = c.customer_id
) > 3;

--Tampilkan nama pelanggan (CustomerName) yang pernah memesan produk dari lebih dari 3 kategori berbeda.
SELECT c.customer_name FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails od ON od.order_id=o.order_id
JOIN products p ON p.product_id=od.product_id
GROUP BY c.customer_name HAVING COUNT(DISTINCT p.category_id)>3;

SELECT c.customer_id, c.customer_name, STRING_AGG(p.product_name,',') AS nama_produk, COUNT(DISTINCT p.category_id) AS jumlah_kategori FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails od ON od.order_id=o.order_id
JOIN products p ON p.product_id=od.product_id
GROUP BY c.customer_id, c.customer_name HAVING COUNT(DISTINCT p.category_id)>3
ORDER BY COUNT(DISTINCT p.category_id)DESC;

--Tampilkan nama supplier (SupplierName) yang memasok produk-produk yang totalnya terjual lebih dari 200 unit ke pelanggan di kota 'London'.

SELECT s.supplier_name 
FROM suppliers s 
JOIN products p ON p.supplier_id=s.supplier_id 
JOIN order_details od ON p.product_id=od.product_id
JOIN orders o ON o.order_id=od.order_id
JOIN customers c ON c.customer_id=o.customer_id
WHERE c.city='London' GROUP by s.supplier_name HAVING SUM(od.quantity)>100;

--1. Tampilkan nama pelanggan (customer_name), nama negara asal supplier (supplier_country), dan total harga pembelian (total_pembelian) untuk setiap pelanggan yang pernah membeli produk dari lebih dari 3 supplier berbeda.
--Tampilkan nama pelanggan (CustomerName), nama produk (ProductName), dan total jumlah produk yang dibeli (TotalQuantity), hanya untuk produk yang: 
--Syarat tambahan:
--1. Hanya tampilkan transaksi yang memiliki total pembelian lebih dari $1000.
--2.Total pembelian dihitung dari SUM(order_details.quantity * order_details.unit_price)
--3.Urutkan hasil dari total pembelian tertinggi ke terendah.
 
SELECT* FROM (SELECT c.customer_name, s.country, SUM(p.price*od.quantity)AS total_harga_pembelian, COUNT(DISTINCT p.supplier_id) AS jumlah_supplier 
FROM suppliers s 
JOIN products p ON p.supplier_id=s.supplier_id 
JOIN orderdetails od ON p.product_id=od.product_id
JOIN orders o ON o.order_id=od.order_id
JOIN customers c ON c.customer_id=o.customer_id
GROUP BY c.customer_name, s.country
HAVING COUNT(DISTINCT p.supplier_id)>1
ORDER BY SUM(p.price*od.quantity) DESC) tb WHERE total_harga_pembelian>1000;

--2. Tampilkan nama pelanggan (CustomerName), nama produk (ProductName), dan total jumlah produk yang dibeli (TotalQuantity), hanya untuk produk yang: 
--1.Pernah dibeli lebih dari 50 unit secara total oleh semua pelanggan
--2. Produk tersebut berasal dari supplier yang berada di negara 'USA'.
--3.hanya tampilkan pelanggan yang pernah memesan lebih dari 2 jenis produk berbeda.
--4.Urutkan hasil berdasarkan TotalQuantity tertinggi ke terendah.

--cara pake tabel bayangan
WITH tabel_baru AS (
  SELECT c.customer_id, c.customer_name, COUNT(p.product_id) AS jumlah_product
  FROM customers c JOIN orders o ON c.customer_id=o.customer_id
  JOIN orderdetails od ON o.order_id=od.order_id
  JOIN products p ON p.product_id=od.product_id
  GROUP BY c.customer_id, c.customer_name HAVING COUNT(p.product_id)>2)

SELECT c.customer_name, p.product_name, tb.jumlah_product, SUM(od.quantity) AS total_unit
FROM customers c 
JOIN tabel_baru tb ON tb.customer_id=c.customer_id
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails od ON o.order_id=od.order_id
JOIN products p ON p.product_id=od.product_id
JOIN suppliers s ON s.supplier_id=p.supplier_id
WHERE s.country='USA' AND tb.jumlah_product>2 
GROUP BY c.customer_name, p.product_name, tb.jumlah_product
HAVING SUM(od.quantity)>50
ORDER BY total_unit DESC;

SELECT*FROM products

--TASK 2
--1. Ubah nama negara pada tabel country Brazil=Indonesia
UPDATE customers c SET country='Indonesia' WHERE country='Brazil';

--2. Hapus data order dan order_details pada tahun 1997
DELETE FROM orderdetails d WHERE d.order_id IN(SELECT o.order_id FROM orders o WHERE EXTRACT (YEAR FROM o.order_date)=1997);
DELETE FROM orders o WHERE EXTRACT(YEAR FROM order_date)=1997;

--cara 2
DELETE FROM orderdetails d USING orders o WHERE d.order_id=o.order_id;

--3.Ubah struktur type column categoryname jadi varchar 100 pada tabel actegories
ALTER TABLE categories
ALTER COLUMN category_name TYPE VARCHAR(100);

--4. Ubah nama produk jadi "makanan dari laut" untuk semua produk dengan kategori seafood
UPDATE products p SET product_name='makanan dari laut' WHERE p.category_id IN(SELECT c.category_id FROM categories c WHERE category_name='Seafood');

--cara2
UPDATE products p SET product_name='makanan dari laut' 
FROM categories c 
WHERE p.category_id=c.category_id 
AND c.category_name='Seafood';

--tampilkan nama kategori yang jumlah produknya lebih dari 1
--A. CARA RIBET
SELECT c.category_name, (SELECT COUNT(p.product_id) FROM products p WHERE p.category_id = c.category_id) AS jumlah_produk
FROM categories c
WHERE c.category_id IN (SELECT category_id FROM products GROUP BY category_id HAVING COUNT(*) > 5 );

--B. CARA LUMAYAN GAMPANG
SELECT 
    c.category_name,
    (SELECT COUNT(p.product_id) FROM products p WHERE p.category_id = c.category_id) AS jumlah_produk
FROM categories c WHERE (SELECT COUNT(product_id) FROM products p WHERE p.category_id = c.category_id) > 5;


SELECT c.category_name, COUNT(p.product_id) AS jumlah_produk
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 5;


SELECT* FROM (
  SELECT c.category_name, COUNT(p.product_id) AS jumlah_produk 
  FROM categories c 
  JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name) dt
WHERE dt.jumlah_produk >6;

-- SUB QUERY
UPDATE products p SET productname='Makanan Dari Laut' WHERE p.categoryid 
IN (SELECT c.categoryid FROM categories c WHERE c.categoryname='Seafood');

-- JOIN
SELECT p.product_name,c.category_name FROM products p 
JOIN categories c ON p.category_id = c.category_id WHERE c.category_name ='Seafood';

-- SUB QUERY
SELECT p.productname,(SELECT c.categoryname FROM categories c WHERE c.categoryid=p.categoryid) 
FROM products p WHERE p.categoryid='8';

-- GROUPING & DISTINCT
SELECT c.categoryname FROM categories c;
SELECT c.categoryname FROM categories c GROUP By c.categoryname;
SELECT distinct c.categoryname FROM categories c;

-- HAVING
SELECT c.categoryname,count(1) FROM categories c 
GROUP BY c.categoryname HAVING COUNT(c.categoryname) > 1;

SELECT c.country,count(c.country) FROM customers c 
GROUP BY c.country HAVING COUNT(c.country) > 4

