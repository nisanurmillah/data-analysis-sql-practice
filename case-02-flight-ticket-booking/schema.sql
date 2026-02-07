CREATE TABLE pelanggan (
id_pelanggan VARCHAR(100) PRIMARY KEY,
nama VARCHAR(100),
email VARCHAR(100),
telepon VARCHAR(100),
alamat VARCHAR(100)
);
CREATE TABLE kota(
  id_kota VARCHAR(100) PRIMARY KEY,
  nama_kota VARCHAR(100),
  provinsi VARCHAR(100),
  negara VARCHAR(100)
);
CREATE TABLE jenis_pesawat(
  id_jenis_pesawat VARCHAR(100) PRIMARY KEY,
  nama_jenis VARCHAR(100),
  deskripsi VARCHAR(100)
);
CREATE TABLE pemesanan (
  id_pemesanan VARCHAR(100) PRIMARY KEY,
  id_pelanggan VARCHAR(100),
  tanggal_pemesanan DATE,
  total_harga DECIMAL(10,2),
  status_pemesanan VARCHAR(100),
  FOREIGN KEY(id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);
CREATE TABLE pesawat(
  id_pesawat VARCHAR(100) PRIMARY KEY,
  id_jenis_pesawat VARCHAR(100),
  nama_pesawat VARCHAR(100),
  nomor_registrasi VARCHAR(100),
  kapasitas_penumpang INT,
  FOREIGN KEY(id_jenis_pesawat) REFERENCES jenis_pesawat(id_jenis_pesawat)
);
CREATE TABLE bandara(
  id_bandara VARCHAR(100) PRIMARY KEY,
  id_kota VARCHAR(100),
  nama_bandara VARCHAR(100),
  kode_icao VARCHAR(100),
  kode_iata VARCHAR(100),
  FOREIGN KEY(id_kota) REFERENCES kota(id_kota)
);
CREATE TABLE penerbangan(
  id_penerbangan VARCHAR(100) PRIMARY KEY,
  id_pesawat VARCHAR(100),
  id_bandara_asal VARCHAR(100),
  id_bandara_tujuan VARCHAR(100),
  waktu_penerbangan TIMESTAMP,
  nomor_penerbangan VARCHAR(100),
  harga_dasar DECIMAL(10,2),
  FOREIGN KEY(id_pesawat) REFERENCES pesawat(id_pesawat),
  FOREIGN KEY(id_bandara_asal) REFERENCES bandara(id_bandara),
  FOREIGN KEY (id_bandara_tujuan) REFERENCES bandara(id_bandara)
);
CREATE TABLE detail_pemesanan(
  id_detail_pemesanan VARCHAR(100) PRIMARY KEY,
  id_pemesanan VARCHAR(100),
  id_penerbangan VARCHAR(100),
  jumlah_penerbangan INTEGER,
  harga_per_kursi DECIMAL(10,2),
  FOREIGN KEY(id_pemesanan) REFERENCES pemesanan(id_pemesanan),
  FOREIGN KEY(id_penerbangan) REFERENCES penerbangan(id_penerbangan)
);

ALTER TABLE penerbangan 
ADD COLUMN waktu_keberangkatan TIMESTAMP,
ADD COLUMN  waktu_kedatangan TIMESTAMP;

ALTER TABLE detail_pemesanan RENAME jumlah_penerbangan to jumlah_penumpang;
