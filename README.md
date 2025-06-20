# Ecommerce Funnel Optimization & Revenue Leakage Analysis

---

## I. Problem Statement

The subject ecommerce platform, despite robust inventory operations and high product exposure, exhibits critical conversion inefficiencies, customer retention shortfalls, behavioral friction, and monetization gaps across its digital sales funnel. Based on a cleaned dataset of ~346,000 user sessions across 303,000 users (post bot-detection filtering), this project investigates performance against 2024–25 global ecommerce benchmarks and proposes targeted, tool-based interventions.

---

## II. Problems to Be Solved

| Problem Area                          | Observed Metric                         | Benchmark / Standard               |
|--------------------------------------|-----------------------------------------|------------------------------------|
| Poor Customer Retention              | Loyal Buyer Rate = 0.06%                | Benchmark = 0.5–2%                 |
| Repeat Engagement Failure            | Repeat Purchase Rate (30d) = 3.6%       | Benchmark = 8–10%                  |
| Funnel Leakage at Cart Stage         | Cart to Purchase Rate = 28.9%           | Industry Leaders ≥ 40%             |
| Wishlist Conversion Failure          | Inactive Favorite Leakage = 93%         | Desired Max ≤ 50%                  |
| Delayed Conversion Latency           | Avg. Conversion Latency = 14.9 hrs      | Benchmark ≤ 12 hrs                 |
| Low Session Retention                | Session 1→2 Retention = 29.5%           | Benchmark = 35–45%                 |
| Limited Product Monetization         | Only 1 High Performer SKU in dataset    | Benchmark: 0.1–1% portfolio share  |
| Category-Level Drop-offs             | Significant χ², Cramér’s V = 0.185      | Category matters → UX prioritization |
| Time-Based Conversion Inefficiency   | Evening peaks statistically significant | Campaigns not aligned              |

---

## III. Dataset Schema (Post-Cleaning)


###  User & Product Identifiers
- `user_id`
- `product_id`
- `category_id`

###  User Actions & Behavior
- `action`
- `converted`
- `favorited`
- `carted`
- `viewed`
- `action_count`

### Time & Session Features
- `timestamp`
- `date`
- `day_of_week`
- `is_weekend`
- `hour_of_day`
- `minute`
- `second`
- `time`
- `day_label`
- `day_type`
- `cohort_day`
- `days_since_signup`

###  Session Tracking
- `prev_action`
- `next_action`
- `action_sequence`
- `time_diff`
- `new_session`
- `session_id`
- `session_duration`
- `session_hours`
- `session_bin`

###  Segmentation & Enrichment
- `user_segment`
- `duration_segment`
- `hour_segment`


---

## IV. Statistical Tests Conducted

- Chi-Square Test for Categorical Association
- Cramér’s V for Effect Size
- Welch’s T-Test for Unequal Variance Mean Comparison
- One-Way ANOVA for Multi-Group Variance
- Proportion Z-Test for Conversion Fluctuation
- McNemar’s Test for Cart→Purchase Asymmetry
- Cohen’s d for Practical Mean Differences
- Cross-tabulation visual analysis

---

## V. Core Solution Framework

## II. Phase-Specific Solution Framework (Post-EDA)

### A. SQL – Action-Oriented Views & Campaign Eligibility

SQL is no longer exploratory—it serves as the decision engine, producing tactical datasets and eligibility views for downstream execution.

| Objective                        | SQL Output Description                                                                  |
|----------------------------------|------------------------------------------------------------------------------------------|
| Cart Abandonment Recovery        | User–product pairs who carted but never purchased within 48–72 hrs                       |
| Wishlist Activation Targeting    | Users who favorited but did not cart or buy, with timestamps and product IDs             |
| Loyalty Campaign Launch          | Users with 1+ past purchases, >30 days since last purchase, and 2+ sessions              |
| Latency-Based Targeting          | Product–user pairs with high time-to-purchase metrics                                    |
| High-Potential SKU Curation      | SKUs with high views or favorites but low conversion rates                               |
| Time-Sensitive Campaign Prep     | Segment purchases/views by hour, flag for scheduling alignment                           |
| Monitoring Tables for Retention  | Weekly cohort retention aggregates for Power BI and Excel                                |

---

### B. Excel – Revenue Forecasting & Scenario Simulation

Excel is used to model business impact of interventions and forecast revenue lift based on SQL-derived targeting logic.

| Problem Area                     | Observed Metric / Gap                       | Industry Expectation / Opportunity         |
| -------------------------------- | ------------------------------------------- | ------------------------------------------ |
| High Cart Abandonment            | 18440+ carts abandoned  → low recovery rate   |11440 carts have recovery potential out of which 20-30% can be converted  Recovery campaigns can yield ₹2–6L gain    |
| Ineffective Wishlist Conversion  | Wishlist SKUs show 93% inactivity           | Activation of top 10% = ₹5L+ opportunity   |
| Loyalty User Shortfall           | Only 0.08% users loyal → below 1% threshold | Strategic push to 1–2% = 231% uplift       |
| Hour-Level Inefficiency          | Non-optimized campaign timing               | ROI peaks in 6–11AM & 9PM–5AM              |
| Latency Friction in Conversions  | Avg. Time to Convert \~14.9 hrs             | Goal: Reduce by 20–40% via segmenting      |
| SKU Attention Without Conversion | High views/favorites, low buys              | Targeted SKU monetization opportunities    |
| Cohort Retention Drop-Off        | Sharp decay post-week 2                     | Retention uplift via time-sensitive nudges |

### C. Power BI – Executive Visibility & Strategic Impact Dashboards

Power BI enables real-time performance monitoring, scenario-based forecasting, and behavioral deep dives using SQL output views and Excel-based simulation layers. Each dashboard is tailored to isolate key revenue and retention gaps while offering actionable clarity for marketing, product, and CRM teams.

| **Dashboard Title**                                                             | **Purpose / Business Objective**                                                                 |
|----------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| **Ecommerce Funnel Overview**                                                   | Holistic funnel leakage view from views → conversions, with segmentation filters                 |
| **Ecommerce User Behavior & Conversion Intelligence**                           | Deep user segmentation by action type, frequency, and conversion history                         |
| **Boosting Checkout: Cart Recovery Strategy**                                   | Visualize revenue leakage via abandoned carts and simulate impact of recovery campaigns          |
| **Revenue Uplift Strategy – High-Impact SKUs**                                  | Monetization insights from highly viewed/favorited but under-converting SKUs                    |
| **SKU Monetization Strategy: Conversion Lift & Focused Targeting**             | Drilldown on SKU attention vs. conversion lag for targeted monetization                         |
| **Retention Uplift Strategy – Daily Cohort Performance**                        | Retention decay curves across cohorts with improvement tracking scenarios                        |
| **User Loyalty Segmentation & Revenue Forecasting**                             | Maps loyalty tiers and forecasts potential revenue from loyalty-based campaigns                 |
| **Campaign Simulation: Gold/Silver User Patterns & Scenarios**                  | Behavior-based targeting and campaign personalization for loyal vs. occasional users             |
| **Simulated Campaign Impact on Latency & Conversion Speed**                     | Benchmarks speed of conversion under campaign vs. organic segments                              |
| **Strategic Campaign Simulation: Wishlist-to-Cart Revenue Lift**                | Projected gains from converting inactive wishlist actions into carts                             |
| **Wishlist SKU Conversion Forecasting**                                         | Conversion and revenue projections under Conservative, Benchmark, and Best-Case assumptions     |

---

## IV. Implementation View

This phase transforms insights into data products and execution logic. Segmentation, behavior tagging, and statistical findings from Python-based EDA are now activated via:

- **SQL** → Materialized views and targeting pipelines  
- **Excel** → Strategic simulations for prioritization and investment  
- **Power BI** → Communication layer for monitoring, buy-in, and decision cadence


