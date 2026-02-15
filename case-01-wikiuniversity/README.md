# Case 01 – WikiUniversity Dataset

## Sales Performance Analysis using Northwind Dataset

### Project Overview

Case study ini menggunakan dataset **Northwind** untuk menganalisis performa penjualan perusahaan distribusi produk makanan dan minuman.

Analisis dilakukan menggunakan SQL dengan pendekatan:

* 01_basic_select → Query dasar untuk eksplorasi data
* 02_join → Analisis relasi antar tabel
* 03_aggregation → Perhitungan total, revenue, dan KPI
* 04_subquery_cte → Analisis lanjutan menggunakan CTE & subquery
* 05_data_manipulation → Simulasi update, delete, dan perubahan struktur data

---

## Project Scope

Proyek ini mencakup eksplorasi dan analisis dataset Northwind dari berbagai aspek bisnis, meliputi:

- Customer Analysis  
- Product Performance  
- Supplier Contribution  
- Employee Performance  
- Order & Revenue Analysis  
- Data Maintenance Simulation  

---

## Business Questions - Sales & Customer Analysis

### 1. Customer Analysis
**Tujuan:** Memahami perilaku pembelian dan nilai customer.  

| No | Business Question | Fokus Analisis |
|----|-----------------|----------------|
| 1  | Siapa saja customer dengan pembayaran tertinggi? | Identifikasi VIP customer untuk strategi loyalitas. |
| 2  | Apa saja produk yang dibeli oleh customer utama? | Rekomendasi upselling / cross-selling. |
| 3  | Customer mana yang membeli produk dari lebih dari 3 kategori atau supplier? | Segmentasi customer loyal dan multi-category. |
| 4  | Berapa total pembelian per customer? | Mengukur Customer Lifetime Value (CLV). |

---

### 2. Product Analysis
**Tujuan:** Memahami performa produk dan profitabilitas.  

| No | Business Question | Fokus Analisis |
|----|-----------------|----------------|
| 1  | Produk apa yang paling banyak terjual? | Menentukan top selling product. |
| 2  | Produk mana yang memiliki kontribusi penjualan terbesar? | Fokus stok & promosi produk unggulan. |
| 3  | Produk berdasarkan kategori atau supplier tertentu? | Strategi kategori & sourcing. |
| 4  | Produk mana yang memiliki potensi keuntungan maksimal? | Pricing strategy dan margin planning. |

---

### 3. Supplier Analysis
**Tujuan:** Memahami kontribusi supplier dan efektivitas sourcing.  

| No | Business Question | Fokus Analisis |
|----|-----------------|----------------|
| 1  | Supplier mana yang memiliki penjualan terbesar? | Menentukan supplier strategis. |
| 2  | Bagaimana kontribusi tiap produk terhadap total penjualan supplier? | Fokus produk unggulan supplier. |
| 3  | Supplier mana yang memasok produk ke kota/kawasan penting? | Optimasi logistik & distribusi. |

---

### 4. Sales / Order Analysis
**Tujuan:** Mengukur performa penjualan dan tren transaksi.  

| No | Business Question | Fokus Analisis |
|----|-----------------|----------------|
| 1  | Total order per kategori atau produk | Mengukur demand per produk/kategori. |
| 2  | Total penjualan per customer dan produk | Mengetahui kontribusi revenue. |
| 3  | Persentase penjualan tiap produk dibanding total | Strategi marketing dan promosi. |
| 4  | Potensi pendapatan jika produk dijual dengan markup tertentu | Forecasting & margin planning. |

---

### 5. Category Analysis
**Tujuan:** Memahami distribusi produk menurut kategori.  

| No | Business Question | Fokus Analisis |
|----|-----------------|----------------|
| 1  | Kategori mana yang memiliki jumlah produk terbanyak? | Inventory planning. |
| 2  | Kategori mana yang paling diminati customer? | Fokus promosi kategori unggulan. |

---

### 6. Data / Operational Maintenance
**Tujuan:** Menjaga data tetap valid dan siap analisis.  

| No | Business Question | Fokus Analisis |
|----|-----------------|----------------|
| 1  | Bagaimana memperbarui nama negara / informasi customer yang salah? | Konsistensi data. |
| 2  | Data order lama atau tidak relevan perlu dihapus? | Membersihkan database untuk analisis akurat. |
| 3  | Perlu update nama produk atau kategori untuk standarisasi? | Standarisasi data untuk laporan dan dashboard. |

---

## Metodologi

nalisis dilakukan menggunakan pendekatan SQL dengan tahapan berikut:

- Data exploration menggunakan SELECT dan filtering
- Penggabungan tabel menggunakan JOIN
- Perhitungan KPI menggunakan agregasi (SUM, COUNT, AVG)
- Segmentasi customer dan produk berdasarkan kontribusi revenue
- Analisis kontribusi supplier
- Penggunaan Subquery dan CTE untuk analisis lanjutan
- Simulasi pricing dan estimasi revenue
- Data cleaning dan standarisasi data

Detail metodologi lengkap tersedia di:  
`analysis/methodology.md`

---

## Key Insights

* Sebagian kecil customer memberikan kontribusi revenue yang sangat besar, menunjukkan peluang kuat untuk program loyalitas dan retensi pelanggan bernilai tinggi.  
* Pola penjualan mengikuti prinsip Pareto: beberapa produk menjadi penyumbang utama total transaksi sehingga perlu prioritas dalam stok dan promosi.  
* Beberapa kategori memiliki volume penjualan tinggi namun tidak selalu menghasilkan revenue terbesar, sehingga evaluasi pricing dan margin diperlukan.  
* Supplier tertentu mendominasi penjualan pada kategori spesifik, membuka peluang negosiasi kontrak atau diversifikasi pemasok. 
* Terdapat customer yang membeli dari banyak kategori sekaligus, yang berpotensi menjadi target strategi cross-selling.  
* Analisis markup menunjukkan adanya ruang optimasi harga untuk meningkatkan profit tanpa harus menaikkan volume penjualan.

---

## Business Recommendations

- Mengembangkan program loyalitas untuk top customer.
- Fokus promosi pada produk high-margin.
- Mengoptimalkan kerja sama strategis dengan supplier utama.
- Menerapkan strategi pricing berbasis data.
- Menjaga konsistensi dan kualitas data untuk analisis jangka panjang.

---
## Dashboard Link
Dashboard dapat diakses di:

https://lookerstudio.google.com/reporting/28e80093-6e43-4611-b0b5-6bba6b5b301a

---

## Repository Structure

Case-01-Northwind/
│
├── README.md
│
├── analysis/
│ ├── methodology.md
│ ├── customer_analysis.md
│ ├── product_analysis.md
│ └── supplier_analysis.md
│
├── queries/
│ ├── 01_basic_select.sql
│ ├── 02_join.sql
│ ├── 03_aggregation.sql
│ ├── 04_subquery_cte.sql
│ └── 05_data_manipulation.sql


---

## Tools Used

- PostgreSQL / SQL
- Supabase (Database Environment)
- GitHub (Version Control)
- Looker studio 

---

**Author:**
Nisa Nurmillah
SQL Data Analysis Practice Project
