-- Calculate Customer Lifetime Value based on tenure and transaction volume
WITH CustomerMetrics AS (
    SELECT 
        u.id AS customer_id,
        u.name,
        DATEDIFF(MONTH, MIN(u.signup_date), GETDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) / 100.0 AS total_transaction_value  -- Convert kobo to naira
    FROM users_customuser u
    INNER JOIN plans_plan p ON u.id = p.owner_id
    INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
    GROUP BY u.id, u.name
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * (total_transaction_value * 0.001), 
        2
    ) AS estimated_clv
FROM CustomerMetrics
ORDER BY estimated_clv DESC;