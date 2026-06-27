CREATE TABLE desa_berlistrik (
    bps_kode_provinsi INTEGER, 
    bps_nama_provinsi TEXT, 
    bps_kode_kabupaten_kota INTEGER, 
    bps_nama_kabupaten_kota TEXT,
    tahun INTEGER, 
    kategori TEXT, 
    jumlah INTEGER, 
    satuan TEXT
);

CREATE TABLE izin_tambang (
    bps_kode_provinsi INTEGER, 
    bps_nama_provinsi TEXT, 
    bps_kode_kabupaten_kota INTEGER, 
    bps_nama_kabupaten_kota TEXT,
    tahun INTEGER, 
    tahap_kegiatan TEXT, 
    jumlah_perusahaan INTEGER, 
    satuan TEXT
);

CREATE TABLE kwh_pln (
    bps_kode_provinsi INTEGER, 
    bps_nama_provinsi TEXT, 
    tahun INTEGER, 
    kwh_dibangkitkan INTEGER, 
    satuan TEXT
);