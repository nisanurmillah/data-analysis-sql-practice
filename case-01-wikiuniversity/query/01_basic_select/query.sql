-- jumlah customer dari london dan jerman
SELECT COUNT(c. customer_id) FROM customers c
WHERE c.country IN ('Germany','London');

--karyawan yang lulusan psychologi
SELECT e. employee_id, e. first_name, e. last_name 
FROM employees e
WHERE notes LIKE '%psychology%'

--siapa saja customer yang berasal dari London dan Garut 
SELECT c.customer_name, c.city FROM customers c WHERE c.city='London' OR c.city='Berlin' OR c.city='garut';

--Daftar produk dari harga tertinggi ke terendah
SELECT p.product_id, p.product_name, p.price
FROM products p
ORDER BY p.price DESC;

--Tampilkan tiap tabel dengan limit 10 baris teratas
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM orderdetails LIMIT 10;
SELECT * FROM products LIMIT 10;

--kategori apa aja yang terdapat pada dataset
SELECT DISTINCT c.categoryname FROM categories c;
