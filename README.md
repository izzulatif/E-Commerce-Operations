# 🛒 E-Commerce Operational & Customer Risk Analysis

## 📌 Executive Summary
An end-to-end SQL data analysis project evaluating regional e-commerce fulfillment bottlenecks and customer order trajectories. This project analyzes order fulfillment lag, sequential customer spending patterns, and category-specific cancellation/return rates to provide actionable recommendations for operations and customer success teams.

---

## 🛠️ Technical Stack & Skills Demonstrated
* **Database Management:** MySQL, Relational Schema Design (`customers`, `orders`)
* **Advanced Querying Techniques:**
  * **Common Table Expressions (CTEs):** Structured intermediate staging for shipping delay metrics.
  * **Window Functions (`LAG`, `PARTITION BY`):** Tracked sequential customer spending progression over time.
  * **Conditional Aggregation (`SUM(CASE WHEN ...)`):** Calculated failure rates dynamically in a single pass without multi-join overhead.
  * **Conditional Logic (`CASE WHEN`, `DATEDIFF`):** Categorized operational metrics into risk tiers.

---

## 🔍 Key Analytical Queries & Business Insights

### 1. Operational Shipping Delay & Tiering
* **Objective:** Quantify the exact delivery lag per order and segment performance into operational health tiers.
* **SQL Implementation:** Utilized a CTE and `DATEDIFF()` to categorize shipments into *Fast (<=3 Days)*, *Moderate (4-6 Days)*, and *Severely Delayed (>6 Days)*.
* **Business Insight:** Highlights fulfillment bottlenecks that directly correlate with customer friction and platform abandonment.

### 2. Order-over-Order Customer Value Trajectory
* **Objective:** Track individual customer spending progression across consecutive transactions.
* **SQL Implementation:** Employed the `LAG()` window function partitioned by `customer_id` ordered chronologically by `order_date`.
* **Business Insight:** Enables the finance team to monitor whether repeat customers increase basket sizes or downgrade spending following delivery delays.

### 3. Category Failure Rate Summary
* **Objective:** Identify which product categories suffer the highest operational failure (cancellations and returns).
* **SQL Implementation:** Leveraged conditional aggregation (`SUM(CASE WHEN order_status IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END)`) paired with `GROUP BY product_category`.
* **Business Insight:** Pinpoints vulnerable product lines that require stricter inventory or vendor oversight.

---

## 📂 Repository Contents
* `ecommerce_analysis.sql` — Contains all creation schemas, sample data injection, and the 3 analytical queries.

---

## 🚀 How to Run the Scripts
1. Open **MySQL Workbench** and connect to your local MySQL instance.
2. Run the schema creation and data insertion scripts to initialize `ecommerce_db`.
3. Open a new query tab (`Ctrl + T`) and execute the analytical queries from `ecommerce_analysis.sql`.