CREATE OR REPLACE FUNCTION kimia_farma.get_persentase_gross_laba(price FLOAT64)
RETURNS FLOAT64 AS (
  CASE
    WHEN price <= 50000 THEN 0.10
    WHEN price <= 100000 THEN 0.15
    WHEN price <= 300000 THEN 0.20
    WHEN price <= 500000 THEN 0.25
    ELSE 0.30
  END
);

CREATE OR REPLACE TABLE kimia_farma.analisa AS
SELECT
  t.transaction_id,
  t.date,
  c.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,
  kimia_farma.get_persentase_gross_laba(p.price) AS persentase_gross_laba,--persentase laba
  (p.price * (1 - t.discount_percentage)) AS nett_sales, --harga setelah diskon
  ((p.price * (1 - t.discount_percentage)) * kimia_farma.get_persentase_gross_laba(p.price)) AS nett_profit, --keuntungan berdasarkan harga setelah diskon * laba
  t.rating AS rating_transaksi
FROM kimia_farma.kf_final_transaction AS t
LEFT JOIN kimia_farma.kf_kantor_cabang AS c
  ON t.branch_id = c.branch_id
LEFT JOIN kimia_farma.kf_product AS p
  ON t.product_id = p.product_id;
