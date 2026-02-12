--JOIN TABEL CUSTOMER, ORDER, ORDER DETAIL, DAN product_id
SELECT * 
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails d ON d.order_id = o.order_id
JOIN products p ON p.product_id = d.product_id;

--list order berupa order_id, tanggal_order, nama produk, na customer, nama pengirim
SELECT o.order_id, o.order_date, p.product_name, c.customer_name, s.shipper_name
FROM shippers s
JOIN orders o ON o.shipper_id = s.shipper_id
JOIN customers c ON c.customer_id = o.customer_id
JOIN orderdetails d ON d.order_id = o.order_id
JOIN products p ON p.product_id = d.product_id;

--jumlah order kategori seafood yang terjual
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

--siapa yang melakukan pembayaran yang paling tinggi?
SELECT c.customer_id, c.customer_name, p.product_name, SUM(d.quantity*p.price) AS total_amount
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN orderdetails d ON o.order_id=d.order_id
JOIN products p ON d.product_id=p.product_id
GROUP BY c.customer_id, c.customer_name, p.product_name
ORDER BY total_amount DESC;

--tampilkan kuantitas dan unit dari produk yang memiliki kata 'gula'
SELECT p.product_id, p.product_name, d.quantity, p.unit
FROM products p  
JOIN orderdetails d ON p.product_id=d.product_id
WHERE p.product_name LIKE '%Gula%';

--Tampilkan nama produk dengan kategori seafood
SELECT p.product_name,c.category_name FROM products p 
JOIN categories c ON p.category_id = c.category_id WHERE c.category_name ='Seafood';

--Tampilkan asal kota yang Kota mana yang memberikan kontribusi pendapatan terbesar, serta berapa jumlah customer dan order di masing-masing kota?
SELECT c.city, COUNT(DISTINCT c.customer_id) AS total_customers, COUNT(o.order_id) as total_order, SUM(od.quantity*p.price) AS total_pendapatan 
FROM products p 
JOIN orderdetails od ON p.product_id=od.product_id
JOIN orders o ON o.order_id=od.order_id
JOIN customers c ON c.customer_id=o.customer_id
GROUP BY c.city
ORDER BY total_pendapatan DESC;
