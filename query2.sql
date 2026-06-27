-- PERTANYAAN 1: Di kabupaten mana jumlah perusahaan tambang paling banyak beroperasi, 
--               dan bagaimana kondisi kelistrikan desanya pada tahun yang sama?
-- TEKNIK: INNER JOIN (Menggabungkan data wilayah)
.print
.print '============================================================='
.print 'JAWABAN 1: DAERAH DENGAN PERUSAHAAN TAMBANG TERBANYAK'
.print '============================================================='

SELECT 
    i.bps_nama_kabupaten_kota AS nama_kabupaten,
    i.tahun,
    SUM(i.jumlah_perusahaan) AS total_perusahaan_tambang,
    d.jumlah AS jumlah_desa_berlistrik
FROM 
    izin_tambang i
INNER JOIN 
    desa_berlistrik d 
    ON i.bps_kode_kabupaten_kota = d.bps_kode_kabupaten_kota 
    AND i.tahun = d.tahun
WHERE 
    d.kategori = 'jumlah_desa_berlistrik' 
    AND i.jumlah_perusahaan > 0
GROUP BY 
    i.bps_nama_kabupaten_kota, 
    i.tahun
ORDER BY 
    total_perusahaan_tambang DESC
LIMIT 5;

-- PERTANYAAN 2: Bagaimana tren pertumbuhan jumlah perusahaan tambang di Aceh 
--               dibandingkan dengan total listrik (kWh) yang dibangkitkan oleh PLN?
-- TEKNIK: CTE (Common Table Expression) & INNER JOIN (Menggabungkan data tahunan)
.print
.print '============================================================='
.print 'JAWABAN 2: TREN JUMLAH TAMBANG VS PRODUKSI LISTRIK PLN (KWH)'
.print '============================================================='

WITH TotalTambangPerTahun AS (
    SELECT 
        tahun, 
        SUM(jumlah_perusahaan) AS total_perusahaan
    FROM 
        izin_tambang
    GROUP BY 
        tahun
)
SELECT 
    t.tahun, 
    t.total_perusahaan, 
    k.kwh_dibangkitkan
FROM 
    TotalTambangPerTahun t
INNER JOIN 
    kwh_pln k 
    ON t.tahun = k.tahun
ORDER BY 
    t.tahun ASC;

-- PERTANYAAN 3: Bagaimana perbandingan rasio total desa dengan jumlah desa yang sudah 
--               berlistrik di wilayah-wilayah pusat "Operasi Produksi" tambang terbesar?
-- TEKNIK: Multiple CTE dan CASE WHEN (Pivoting Data)
.print
.print '============================================================='
.print 'JAWABAN 3: RASIO DESA BERLISTRIK DI PUSAT OPERASI TAMBANG'
.print '============================================================='

WITH DataListrik AS (
    SELECT 
        bps_kode_kabupaten_kota,
        bps_nama_kabupaten_kota,
        tahun,
        MAX(CASE WHEN kategori = 'jumlah_desa' THEN CAST(jumlah AS INTEGER) END) AS total_desa,
        MAX(CASE WHEN kategori = 'jumlah_desa_berlistrik' THEN CAST(jumlah AS INTEGER) END) AS desa_berlistrik
    FROM 
        desa_berlistrik
    GROUP BY 
        bps_kode_kabupaten_kota, 
        tahun
),
DataTambang AS (
    SELECT 
        bps_kode_kabupaten_kota,
        tahun,
        SUM(jumlah_perusahaan) AS total_produksi
    FROM 
        izin_tambang
    WHERE 
        tahap_kegiatan LIKE '%Operasi Produksi%'
    GROUP BY 
        bps_kode_kabupaten_kota, 
        tahun
)
SELECT 
    l.bps_nama_kabupaten_kota,
    l.tahun,
    l.total_desa,
    l.desa_berlistrik,
    t.total_produksi AS jumlah_tambang_produksi
FROM 
    DataListrik l
INNER JOIN 
    DataTambang t 
    ON l.bps_kode_kabupaten_kota = t.bps_kode_kabupaten_kota 
    AND l.tahun = t.tahun
ORDER BY 
    t.total_produksi DESC
LIMIT 5;