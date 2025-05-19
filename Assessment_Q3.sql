-- Find active accounts with no transactions in the last 365 days
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(DAY, MAX(s.transaction_date), GETDATE()) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
HAVING DATEDIFF(DAY, MAX(s.transaction_date), GETDATE()) > 365
   OR MAX(s.transaction_date) IS NULL
ORDER BY inactivity_days DESC;