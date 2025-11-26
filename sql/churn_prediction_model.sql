CREATE OR REPLACE MODEL web3_mining_data.churn_prediction_model
OPTIONS(
    model_type='LOGISTIC_REG', 
    input_label_cols=['is_churn'],
    data_split_method='AUTO_UNBALANCED'
) AS
SELECT
    recency,
    frequency,
    ltv_cumulative,
    cac_per_customer,
    customer_age_days,
    is_churn
FROM
  web3_mining_data.v_kpis_transformed
WHERE
  customer_id IS NOT NULL;