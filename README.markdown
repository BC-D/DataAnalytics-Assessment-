# DataAnalytics-Assessment

This repository contains my SQL solutions for the Cowrywise Data Analyst Assessment. Below, I explain my approach to each question and document challenges faced during development.

## Question 1: High-Value Customers with Multiple Products
**Approach**: 
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount` to link customers to their plans and transactions.
- Used conditional aggregation to count savings (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`).
- Filtered for customers with at least one of each plan type using a `HAVING` clause.
- Converted `confirmed_amount` from kobo to naira by dividing by 100.
- Sorted by total deposits in descending order for business relevance.

**Challenges**:
- Ensuring only funded plans were counted required careful filtering on `savings_savingsaccount`.
- Initially forgot to convert kobo to naira, which I fixed after reviewing the output format.

## Question 2: Transaction Frequency Analysis
**Approach**: 
- Calculated average transactions per customer per month by joining `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Used `DATEDIFF` to compute the account’s active months and divided transaction count by this period.
- Categorized into High (≥10), Medium (3-9), and Low (≤2) frequency using a `CASE` statement.
- Grouped by frequency category and computed average transactions per category.

**Challenges**:
- Handling customers with short account durations (e.g., 1 month) to avoid division-by-zero errors; added 1 to `DATEDIFF` to mitigate this.
- Ensuring accurate categorization required testing boundary conditions (e.g., exactly 3 or 10 transactions).

## Question 3: Account Inactivity Alert
**Approach**: 
- Joined `plans_plan` with `savings_savingsaccount` to find the last transaction date per plan.
- Used `DATEDIFF` to calculate days since the last transaction, flagging plans with >365 days or no transactions.
- Determined plan type (Savings or Investment) using a `CASE` statement based on `is_regular_savings` and `is_a_fund`.
- Included `NULL` transaction dates to account for plans with no activity.

**Challenges**:
- Handling plans with no transactions (NULL dates) required careful logic in the `HAVING` clause.
- Verified `GETDATE()` was appropriate for SQL Server; considered time zones but assumed standard server time.

## Question 4: Customer Lifetime Value (CLV) Estimation
**Approach**: 
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount` to compute tenure and transaction metrics.
- Calculated tenure using `DATEDIFF` between signup date and current date.
- Computed CLV as `(total_transactions / tenure) * 12 * (total_transaction_value * 0.001)` for 0.1% profit.
- Used `NULLIF` to avoid division-by-zero for new accounts.
- Ordered by CLV descending to prioritize high-value customers.

**Challenges**:
- Converting `confirmed_amount` from kobo to naira was critical for accurate CLV calculations.
- Ensuring tenure wasn’t zero required careful handling with `NULLIF`.
- Rounded CLV to 2 decimal places for readability, as per the expected output.

## General Notes
- All queries were tested in a local SQL Server environment to ensure correctness and efficiency.
- Used consistent indentation and comments to improve readability, as per submission guidelines.
- Focused on straightforward joins and aggregations to balance performance and clarity, avoiding overly complex subqueries.

## Submission
This repository contains all required SQL files and this README, adhering to the specified structure. The queries are my original work, designed to meet the assessment’s criteria for accuracy, efficiency, and readability.