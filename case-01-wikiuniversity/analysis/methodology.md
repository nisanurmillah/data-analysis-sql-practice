## Metodologi Analisis Bisnis

### 1. Tujuan Analisis
Analisis ini dilakukan untuk mendapatkan **insight bisnis yang relevan** dari data penjualan, customer, produk, dan supplier. Tujuan utama dari analisis ini adalah:  
1. Memahami **perilaku customer**, termasuk segmentasi berdasarkan nilai pembelian, jenis produk yang dibeli, dan loyalty terhadap kategori atau supplier tertentu.  
2. Mengevaluasi **performa produk**, menentukan produk terlaris, produk dengan kontribusi penjualan terbesar, dan potensi keuntungan dari setiap produk.  
3. Menilai **kontribusi supplier** dan efektivitas strategi sourcing, serta menentukan supplier strategis berdasarkan penjualan produk dan area distribusi.  
4. Mendukung pengambilan keputusan strategis terkait **penjualan, promosi, inventory, dan pricing**.

### 2. Sumber Data
Analisis ini menggunakan data historis yang berasal dari beberapa tabel utama:  
- **Customers**: menyimpan informasi customer termasuk nama, kota, dan negara.  
- **Orders**: menyimpan data transaksi, tanggal order, dan pengirim.  
- **OrderDetails**: menyimpan rincian produk yang dibeli, termasuk jumlah dan harga.  
- **Products**: menyimpan informasi produk, kategori, harga, dan supplier.  
- **Suppliers**: menyimpan informasi supplier dan negara asalnya.  
- **Categories**: menyimpan kategori produk.  

Sebelum analisis, data dilakukan **pembersihan dan standarisasi**, antara lain:  
- Koreksi nama negara dan kota agar konsisten.  
- Penghapusan data order lama atau tidak relevan.  
- Standarisasi nama produk berdasarkan kategori dan supplier.  

### 3. Pendekatan Analisis
Pendekatan analisis dilakukan dengan menggabungkan **metode deskriptif dan kuantitatif**. Beberapa langkah yang dilakukan antara lain:  

#### Customer Analysis
- Identifikasi customer dengan pembayaran tertinggi untuk menentukan **VIP customer**.  
- Menentukan produk yang dibeli oleh setiap customer untuk strategi **upselling dan cross-selling**.  
- Mengelompokkan customer yang membeli dari lebih dari 3 kategori atau supplier untuk segmentasi **loyal dan multi-category**.  
- Menghitung total pembelian per customer untuk menghitung **Customer Lifetime Value (CLV)**.

#### Product Analysis
- Menghitung jumlah unit terjual per produk dan kategori.  
- Menilai kontribusi tiap produk terhadap total penjualan.  
- Menganalisis potensi keuntungan dengan asumsi markup tertentu.  
- Mengidentifikasi produk unggulan untuk strategi **stok dan promosi**.

#### Supplier Analysis
- Menentukan supplier dengan penjualan terbesar.  
- Mengukur kontribusi tiap produk terhadap total penjualan supplier.  
- Mengidentifikasi supplier yang memasok produk ke kota atau kawasan strategis untuk **optimasi distribusi**.

#### Sales / Order Analysis
- Evaluasi total order per kategori dan produk.  
- Menghitung persentase kontribusi penjualan tiap produk terhadap total penjualan.  
- Mengestimasi potensi pendapatan jika produk dijual dengan harga target tertentu.

#### Category Analysis
- Menghitung jumlah produk per kategori.  
- Menentukan kategori yang paling diminati customer untuk **fokus promosi dan inventori**.

### 4. Teknik Analisis
Beberapa teknik analisis yang digunakan meliputi:  
- **Join dan Aggregasi**: Menggabungkan beberapa tabel untuk menghitung total penjualan, total unit, dan kontribusi supplier atau produk.  
- **Filter dan Segmentasi**: Memisahkan data berdasarkan kategori, supplier, lokasi customer, atau tahun transaksi.  
- **Subquery dan CTE (Common Table Expressions)**: Membuat tabel bayangan untuk perhitungan total per supplier, produk, atau customer.  
- **Perhitungan KPI**: Total pembelian, total unit terjual, persentase kontribusi produk, dan potensi keuntungan.  
- **Fungsi Statistik Dasar**: SUM, COUNT, AVG, dan STRING_AGG untuk merangkum informasi.

### 5. Visualisasi
Hasil analisis dapat divisualisasikan untuk mendukung pengambilan keputusan, antara lain:  
- **Top Customer / Revenue Contribution** → Bar chart atau Pie chart.  
- **Produk Terlaris & Kontribusi Penjualan** → Column chart atau Pareto chart.  
- **Supplier Kontribusi Produk** → Stacked bar chart.  
- **Distribusi Penjualan Per Kategori** → Pie chart atau Tree map.  

### 6. Kesimpulan
Metodologi ini memungkinkan perusahaan untuk:  
- Menentukan strategi penjualan dan promosi berdasarkan data aktual.  
- Mengoptimalkan stok dan inventori produk unggulan.  
- Memprioritaskan supplier strategis untuk efisiensi sourcing dan distribusi.  
- Merencanakan harga jual dan potensi keuntungan dengan lebih akurat.  
- Mendukung pengambilan keputusan berbasis data untuk pertumbuhan bisnis.
