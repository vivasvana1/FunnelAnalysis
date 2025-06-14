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

| Objective                        | Excel Use Case                                                                          |
|----------------------------------|------------------------------------------------------------------------------------------|
| Loyalty Uplift Forecasting       | Project revenue increase from 0.06% → 1–2% loyal user base                              |
| Cart Recovery ROI Modeling       | Simulate impact of recovering 20–30% of abandoned carts                                 |
| Wishlist Activation Forecasting  | Project conversion value from activating top 10% favorited SKUs                         |
| SKU Monetization Scenario        | Track impact of converting “high attention but unsold” products                         |
| Campaign Cost-Benefit Modeling   | Compare time-based campaign conversion effectiveness and cost efficiency                |

---

### C. Power BI – Real-Time Visibility & Performance Monitoring

Power BI provides executive visibility into funnel performance post-intervention, using data flows connected to SQL outputs and Excel models.

| Objective                        | BI Dashboard Modules                                                                    |
|----------------------------------|------------------------------------------------------------------------------------------|
| Funnel Progression Dashboard     | Real-time drop-off tracking by segment (View → Favorite → Cart → Purchase)              |
| SKU Performance Matrix           | Visual mapping of product tiers by conversion and engagement                            |
| Retention & Cohort Heatmaps      | Day/week cohort tracking by user segment and purchase behavior                          |
| Latency Distributions            | Purchase timing analysis by segment, product, and hour                                  |
| Campaign Readiness & Eligibility | Visual trackers of user counts meeting SQL flag logic (loyalty, cart, etc.)             |

---

## IV. Implementation View

This phase transforms insights into data products and execution logic. Segmentation, behavior tagging, and statistical findings from Python-based EDA are now activated via:

- **SQL** → Materialized views and targeting pipelines  
- **Excel** → Strategic simulations for prioritization and investment  
- **Power BI** → Communication layer for monitoring, buy-in, and decision cadence

