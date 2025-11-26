SELECT
    CASE 
        -- Check 1: Fails if zero rows were ingested (critical error)
        WHEN COUNT(*) = 0 THEN 'Error: No rows ingested.'
        -- Check 2: Fails if the latest transaction is older than 7 days (data is stale)
        WHEN DATE_DIFF(CURRENT_DATE(), MAX(transaction_date), DAY) > 7 THEN 'Error: Data is stale (> 7 days).'
        -- If all checks pass
        ELSE 'Health Check: OK'
    END AS data_health_status
FROM
    web3_mining_data.customer_transactions