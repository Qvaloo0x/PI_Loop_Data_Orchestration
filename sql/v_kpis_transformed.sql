CREATE OR REPLACE VIEW web3_mining_data.v_kpis_transformed AS
WITH
  LatestDate AS (
  SELECT
    MAX(transaction_date) AS max_date
  FROM
    web3_mining_data.customer_transactions),
  CustomerSummary AS (
  SELECT
    t1.customer_id,
    MAX(t1.transaction_date) AS last_transaction_date,
    DATE_DIFF((SELECT max_date FROM LatestDate), MAX(t1.transaction_date), DAY) AS recency,
    COUNT(t1.transaction_date) AS frequency,
    SUM(t1.revenue) AS ltv_cumulative,
    -- Labeling Churn: True if no transaction in the last 60 days
    CASE
      WHEN DATE_DIFF((SELECT max_date FROM LatestDate), MAX(t1.transaction_date), DAY) > 60 THEN 1
    ELSE
    0
  END
    AS is_churn,
    MIN(t1.transaction_date) AS first_transaction_date
  FROM
    web3_mining_data.customer_transactions AS t1
  GROUP BY
    1
),
  MarketingData AS (
  SELECT
    SUM(total_cost) AS total_marketing_cost,
    SUM(new_customers_acquired) AS total_new_customers
  FROM
    web3_mining_data.marketing_spend
)
SELECT
  s.customer_id,
  s.recency,
  s.frequency,
  s.ltv_cumulative,
  s.is_churn,
  -- Simple CAC calculation based on total spend / total acquired customers
  (SELECT total_marketing_cost FROM MarketingData) / (SELECT total_new_customers FROM MarketingData) AS cac_per_customer,
  DATE_DIFF(CURRENT_DATE(), s.first_transaction_date, DAY) AS customer_age_days
FROM
  CustomerSummary AS s
WHERE
  s.first_transaction_date IS NOT NULL