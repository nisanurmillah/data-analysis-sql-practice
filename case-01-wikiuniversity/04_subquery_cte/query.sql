--Berapa kontribusi setiap produk terhadap total pendapatan suppliernya
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

--atau bisa juga seperti berikut
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

--Tampilkan customer yang telah membeli produk dari lebih dari 3 kategori berbeda.
SELECT customer_name
FROM customers c
WHERE (
  SELECT COUNT(DISTINCT p.category_id)
  FROM orders o
  JOIN orderdetails od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id
  WHERE o.customer_id = c.customer_id
) > 3;

--atau bisa juga
SELECT 
  c.customer_name, COUNT(cat.category_id) AS jumlah_kategori
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN orderdetails od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(cat.category_id) > 3;

----Tampilkan nama pelanggan (CustomerName), nama produk (ProductName), dan jumlah produk yang dibeli (TotalQuantity), hanya untuk produk yang: 
--Pernah dibeli lebih dari 50 unit secara total oleh semua pelanggan
--Produk tersebut berasal dari supplier yang berada di negara 'USA'.
--hanya tampilkan pelanggan yang pernah memesan lebih dari 2 jenis produk berbeda.
--Urutkan hasil berdasarkan TotalQuantity tertinggi ke terendah.

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

--Tampilkan daftar semua produk beserta jumlah unit yang terjual, dan persentase kontribusi tiap produk dari total penjualan
SELECT 
  p.product_id,
  p.product_name,
  SUM(d.quantity) AS total_sold,
  (SELECT SUM(quantity) FROM orderdetails) AS total_all_sold,
  ROUND(SUM(d.quantity) * 100.0 / (SELECT SUM(quantity) FROM orderdetails), 2) AS pct_of_total
FROM products p
LEFT JOIN orderdetails d ON p.product_id = d.product_id
GROUP BY p.product_id, p.product_name;

--Tampilkan nama customer yang membeli produk lebih dari 3 kategori
SELECT customer_name
FROM customers c
WHERE (
  SELECT COUNT(DISTINCT p.category_id)
  FROM orders o
  JOIN orderdetails od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id
  WHERE o.customer_id = c.customer_id
) > 3;

--Tampilkan nama pelanggan, nama negara asal supplier, dengan total harga pembelian lebuh dari 1000 untuk setiap pelanggan yang pernah membeli produk dari lebih dari 1 supplier 
SELECT* FROM (
    SELECT c.customer_name, 
    s.country, 
    SUM(p.price*od.quantity)AS total_harga_pembelian, 
    COUNT(DISTINCT p.supplier_id) AS jumlah_supplier 
    FROM suppliers s 
    JOIN products p ON p.supplier_id=s.supplier_id 
    JOIN orderdetails od ON p.product_id=od.product_id
    JOIN orders o ON o.order_id=od.order_id
    JOIN customers c ON c.customer_id=o.customer_id
    GROUP BY c.customer_name, s.country
    HAVING COUNT(DISTINCT p.supplier_id)>1
    ORDER BY SUM(p.price*od.quantity) DESC) tb 
WHERE total_harga_pembelian>1000;

--Tampilkan nama kategori yang memiliki jumlah produk lebih dari 6
SELECT* FROM (
  SELECT c.category_name, COUNT(p.product_id) AS jumlah_produk 
  FROM categories c 
  JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name) dt
WHERE dt.jumlah_produk >6;





