--Siapa yang melakukan pembayaran paling tinggi dan produk apa saja yag dibeli
SELECT c.customer_id, c.customer_name, SUM(d.quantity*p.price) AS total_amount, STRING_AGG(p.product_name,',') AS nama_produk
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

--Tampilkan customer yang melakukan pembayaran paling tinggi, nama produk yang dibeli beserta jumlahnya
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

--Tampilkan detail transaksi produk yang dibeli customer dengan pembayaran tertinggi tersebut
SELECT c.customer_id, c.customer_name, p.product_name, d.quantity, p.price, SUM(p.price*d.quantity) AS total_bayar
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
WHERE c.customer_id='20'
GROUP BY c.customer_id, c.customer_name, p.product_name, d.quantity, p.price
ORDER BY total_bayar DESC;

-- Tampilkan produk dengan penjualan teringgi beserta customer yang membelinya
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

--Berapa persentase jumlah produk yang terjual dibandingkan jumlah keseluruhan produk ?
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

--apa saja produk yang disupply supplier tersebut
SELECT p.product_id, p.product_name, p.unit, p.price, s.supplier_name
FROM products p
JOIN suppliers s ON s.supplier_id=p.supplier_id
WHERE supplier_name LIKE '%Formaggi Fortini%'
ORDER BY p.price DESC;

--Tampilkan data produk yang dibeli berdasarkan karyawan
SELECT c.customer_id, c.customer_name, SUM(d.quantity*p.price) AS total_amount, STRING_AGG(p.product_name,',') AS nama_produk_yang_dibeli
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_amount DESC;

--Berapa total pendapatan per produk, dan seberapa besar persentasenya terhadap total penjualan?
SELECT
  p.product_id,
  p.product_name,
  COALESCE(SUM(p.price * d.quantity), 0) AS total_terjual,
  ROUND(                              -------------ROUND= untuk memfilter desimalnya berapa ROUND(angka, jumlah desimal)
    COALESCE(SUM(p.price * d.quantity), 0) / ------COALESCE (hasil,0)
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

--Tampilkan Suplier terbesar pada dataset tersebut
SELECT s.supplier_id, s.supplier_name, STRING_AGG(p.product_name,',') AS jenis_produk, 
COUNT(p.product_name) AS total_product, 
  SUM(p.price*d.quantity) AS total_dana
FROM suppliers s
JOIN products p ON p.supplier_id=s.supplier_id
JOIN orderdetails d ON d.product_id=p.product_id
GROUP by s.supplier_id, s.supplier_name
ORDER by total_product DESC;

--Tampilkan harga produk yang harus dijual pembeli untuk mendapat keuntungan 25% dari harga modal
SELECT  p.product_name, 
        p.unit, p.price, 
      ((p.price/substring(p.unit FROM '^\d+')::numeric)*1.25) AS harga_per_satuan 
FROM products p 
GROUP BY p.product_name, p.unit, p.price 
ORDER BY harga_per_satuan DESC;

--Tmpilkan total pendapatan yang akan didapatkan jika product yang dibeli customer terjual semua dengan harga jual mengambil keuntungan 50%
SELECT p.product_name, p.unit, p.price, 
      ((p.price/substring(p.unit FROM '^\d+')::numeric)*1.50) AS harga_per_satuan,
      (((p.price/substring(p.unit FROM '^\d+')::numeric)*1.50) * substring (p.unit FROM '^\d+')::numeric) AS pendapatan_kotor
FROM products p GROUP BY p.product_name, p.unit, p.price ORDER BY pendapatan_kotor DESC;

--Tampilkan customer yang membeli lebih dari 3 kategori produk berbeda
SELECT c.customer_name FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails od ON od.order_id=o.order_id
JOIN products p ON p.product_id=od.product_id
GROUP BY c.customer_name HAVING COUNT(DISTINCT p.category_id)>3;

--Tampilkan pelanggan yang membeli produk dari lebih dari 3 kategori berbeda, beserta daftar semua produk yang mereka beli, dan jumlah kategori unik yang dibeli. Urutkan dari pelanggan dengan kategori terbanyak ke paling sedikit
SELECT c.customer_id, c.customer_name, STRING_AGG(p.product_name,',') AS nama_produk, COUNT(DISTINCT p.category_id) AS jumlah_kategori FROM customers c 
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails od ON od.order_id=o.order_id
JOIN products p ON p.product_id=od.product_id
GROUP BY c.customer_id, c.customer_name HAVING COUNT(DISTINCT p.category_id)>3
ORDER BY COUNT(DISTINCT p.category_id)DESC;




