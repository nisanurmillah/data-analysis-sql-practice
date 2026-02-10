# Basic Select & Filtering

Folder ini berisi query SQL dasar untuk menampilkan dan memfilter data.

## Analisis yang Dilakukan
- Menampilkan data customer, orders, dan produk
- Filtering berdasarkan kota dan negara
- Sorting data berdasarkan harga
- Menggunakan DISTINCT untuk menghindari duplikasi

## Insight
Query dasar ini menjadi fondasi untuk analisis lanjutan,
terutama sebelum data digabungkan dengan tabel lain.

## Exploratory Questions & Results

### 1. Berapa jumlah customer dari London dan Jerman?
Terdapat **11 customer** yang berasal dari **kota London** dan **negara Jerman**.

### 2. Siapa saja karyawan yang memiliki latar belakang psikologi?
Karyawan dengan latar belakang psikologi adalah:
- Nancy Davolio
- Laura Callahan

### 3. Siapa saja customer yang berasal dari London, Berlin, dan Garut?
Customer yang berasal dari kota tersebut antara lain:
- Alfreds Futterkiste (Berlin)
- Around the Horn (London)
- B's Beverages (London)
- Consolidated Holdings (London)
- Eastern Connections (London)
- North/South (London)
- Seven Seas Imports (London)
- Nisa (Garut)
- Zaki (Garut)

### 4. Produk dengan harga tertinggi dan terendah
- Produk dengan **harga tertinggi** adalah **Côte de Blaye** dengan harga **263.50**
- Produk dengan **harga terendah** adalah **Geitost** dengan harga **2.50**

## Kesimpulan

Berdasarkan eksplorasi awal menggunakan query SELECT dasar,
dataset menunjukkan bahwa:

- Customer berasal dari beberapa kota dan negara berbeda,
  dengan konsentrasi cukup tinggi di kota London.
- Dataset mencakup customer dari berbagai kota dan negara,
  namun distribusinya belum dapat disimpulkan secara menyeluruh
  tanpa perbandingan kuantitatif antar seluruh lokasi.
- Informasi latar belakang karyawan dapat diidentifikasi dari kolom teks,
  seperti riwayat pendidikan.
- Terdapat variasi harga produk yang cukup lebar,
  dari produk dengan harga rendah hingga produk premium.

Eksplorasi ini membantu memahami karakteristik data
sebelum dilakukan analisis lanjutan seperti JOIN dan AGGREGATION.

