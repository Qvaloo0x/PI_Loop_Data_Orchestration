CREATE OR REPLACE TABLE web3_mining_data.t_churn_predictions AS
SELECT
  t2.customer_id,
  t2.predicted_is_churn,
  t2.predicted_is_churn_probs[OFFSET(1)].prob AS churn_probability, -- Probability that churn = 1
  t1.ltv_cumulative,
  t1.cac_per_customer
FROM
  ML.PREDICT(MODEL web3_mining_data.churn_prediction_model,
    (
      SELECT
        *
      FROM
        web3_mining_data.v_kpis_transformed
    )
  ) AS t2 -- Prediction Output
JOIN
  web3_mining_data.v_kpis_transformed AS t1 -- Join back to get KPI data
ON
  t2.customer_id = t1.customer_id
WHERE
  t2.predicted_is_churn_probs[OFFSET(1)].prob > 0.10 -- Optional filter: Only show high-risk users on the dashboard