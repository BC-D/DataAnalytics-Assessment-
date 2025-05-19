-- Calculate average transactions per customer per month and categorize frequency
WITH TransactionCounts AS (
    SELECT 
        u.id,
        COUNT(s.id) / (DATEDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1) AS avg_transactions_per_month
    FROM users_customuser u
    INNER JOIN plans_plan p ON u.id = p.owner_id
    INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
    GROUP BY u.id
)
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM TransactionCounts
GROUP BY 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END
ORDER BY avg_transactions_per_month DESC;