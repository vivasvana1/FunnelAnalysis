create database FunnelOptimizationDB;
Go
Use FunnelOptimizationDB;

CREATE TABLE FunnelStaging (
    user_id VARCHAR(50),
    product_id VARCHAR(50),
    category_id VARCHAR(50),
    action VARCHAR(10),
    timestamp VARCHAR(50),
    date VARCHAR(20),
    day_of_week VARCHAR(5),
    is_weekend VARCHAR(5),
    hour_of_day VARCHAR(5),
    minute VARCHAR(5),
    second VARCHAR(5),
    prev_action VARCHAR(10),
    next_action VARCHAR(10),
    action_sequence VARCHAR(5),
    time_diff VARCHAR(50),
    new_session VARCHAR(5),
    session_id VARCHAR(50),
    session_duration VARCHAR(50),
    action_count VARCHAR(5),
    converted VARCHAR(5),
    favorited VARCHAR(5),
    carted VARCHAR(5),
    viewed VARCHAR(5),
    user_segment VARCHAR(20),
    duration_segment VARCHAR(20),
    hour_segment VARCHAR(20)
);
BULK INSERT FunnelStaging
FROM 'C:\Users\priya\Downloads\FunnelAnalysis_2.csv'
WITH (
    FIRSTROW = 2, -- skip header
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001', -- UTF-8 safe
    FORMAT = 'CSV'
);



CREATE TABLE FunnelCleaned (
    user_id INT,
    product_id INT,
    category_id INT,
    action VARCHAR(20),
    timestamp DATETIME,
    date VARCHAR(20),  -- or use DATE if formatted as yyyy-MM-dd
    day_of_week INT,
    is_weekend BIT,
    hour_of_day INT,
    minute INT,
    second INT,
    prev_action VARCHAR(20),
    next_action VARCHAR(20),
    action_sequence INT,
    time_diff FLOAT,
    new_session BIT,
    session_id INT,
    session_duration INT,
    action_count INT,
    converted BIT,
    favorited BIT,
    carted BIT,
    viewed BIT,
    user_segment VARCHAR(20),
    duration_segment VARCHAR(20),
    hour_segment VARCHAR(20)
);
INSERT INTO FunnelCleaned (
    user_id, product_id, category_id, action,
    timestamp, date, day_of_week, is_weekend,
    hour_of_day, minute, second,
    prev_action, next_action, action_sequence,
    time_diff, new_session, session_id, session_duration,
    action_count, converted, favorited, carted, viewed,
    user_segment, duration_segment, hour_segment
)
SELECT
    CAST(user_id AS INT),
    CAST(product_id AS INT),
    CAST(category_id AS INT),
    action,
    CAST(timestamp AS DATETIME),
    date,
    CAST(day_of_week AS INT),
    CAST(is_weekend AS BIT),
    CAST(hour_of_day AS INT),
    CAST(minute AS INT),
    CAST(second AS INT),
    prev_action,
    next_action,
    CAST(action_sequence AS INT),
    CAST(NULLIF(time_diff, 'null') AS FLOAT),
    CAST(new_session AS BIT),
    CAST(session_id AS INT),
    CAST(session_duration AS INT),
    CAST(action_count AS INT),
    CAST(converted AS BIT),
    CAST(favorited AS BIT),
    CAST(carted AS BIT),
    CAST(viewed AS BIT),
    user_segment,
    duration_segment,
    hour_segment
FROM FunnelStaging;
SELECT TOP 5 * FROM FunnelCleaned;


--- Cart Abandonment Recovery---
-- Simulating cart abandonment check relative to Dec 3, 2017 at 6 PM
GO
CREATE VIEW vw_CartAbandonment_ByCategory AS
SELECT 
    user_id,
    category_id,
    MAX(timestamp) AS last_carted_at
FROM FunnelCleaned
WHERE carted = 1 AND converted = 0
GROUP BY user_id, category_id
HAVING DATEDIFF(HOUR, MAX(timestamp), '2017-12-03 16:09:25') BETWEEN 0 AND 72;
GO

---Target users who favorited products but did not cart or buy.
GO
CREATE VIEW vw_WishlistActivationTargets AS
SELECT 
    user_id,
    product_id,
    MAX(timestamp) AS favorited_at
FROM FunnelCleaned
GROUP BY user_id, product_id
HAVING 
    SUM(CAST(favorited AS INT)) >= 1 AND 
    SUM(CAST(carted AS INT)) = 0 AND 
    SUM(CAST(converted AS INT)) = 0;

-- Loyalty Campaign Candidates: Enhanced View
-- Includes users with at least 1 past conversion, at least 2 sessions,
-- and have been inactive for 2+ days before dataset end (2017-12-03)
GO
create VIEW vw_LoyaltyCampaignCandidates AS
SELECT 
    user_id,
    COUNT(DISTINCT session_id) AS total_sessions,
    SUM(CAST(converted AS INT)) AS total_purchases,
    MAX(CASE WHEN converted = 1 THEN timestamp END) AS last_purchase_time,
    DATEDIFF(DAY, MAX(CASE WHEN converted = 1 THEN timestamp END), '2017-12-03') AS days_since_last_purchase,
    CASE 
        WHEN COUNT(DISTINCT session_id) >= 10 THEN 'Platinum'
        WHEN COUNT(DISTINCT session_id) >= 5 THEN 'Gold'
        WHEN COUNT(DISTINCT session_id) >= 2 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier
FROM FunnelCleaned
GROUP BY user_id
HAVING 
    COUNT(DISTINCT session_id) >= 2 AND 
    SUM(CAST(converted AS INT)) >= 1 AND 
    MAX(CASE WHEN converted = 1 THEN timestamp END) IS NOT NULL AND
    DATEDIFF(DAY, MAX(CASE WHEN converted = 1 THEN timestamp END), '2017-12-03') > 2;

---Find product–user pairs where conversion took longer than average.
GO
CREATE VIEW vw_HighLatencyConversions AS
SELECT 
    user_id,
    product_id,
    AVG(time_diff) AS avg_time_to_convert
FROM FunnelCleaned
WHERE converted = 1 AND time_diff IS NOT NULL
GROUP BY user_id, product_id
HAVING AVG(time_diff) > 3600; -- 60 Hrs

---Identify high-interest, low-conversion SKUs.
GO
CREATE VIEW vw_HighPotentialSKUs AS
SELECT 
    category_id,
    COUNT(*) AS total_actions,
    SUM(CAST(viewed AS INT)) AS total_views,
    SUM(CAST(favorited AS INT)) AS total_favorites,
    SUM(CAST(carted AS INT)) AS total_carted,
    SUM(CAST(converted AS INT)) AS total_converted
FROM FunnelCleaned
GROUP BY category_id
HAVING 
    SUM(CAST(viewed AS INT)) >= 1500 AND 
    SUM(CAST(converted AS INT)) <= 50;
---Analyze user behavior by hour to optimize email/notification timing.
Go
CREATE VIEW vw_HourlyEngagement AS
SELECT 
    hour_of_day,
    COUNT(*) AS total_actions,
    SUM(CAST(viewed AS INT)) AS views,
    SUM(CAST(carted AS INT)) AS carted,
    SUM(CAST(converted AS INT)) AS converted
FROM FunnelCleaned
GROUP BY hour_of_day;

---Create weekly user cohorts to track returning behavior and retention.---
go
-- Assume date is in format 'dd-mm-yy' as string
-- Cohort Retention Monitoring View


    -- Enhanced view for excel 
GO
-- View 1: Weekly User Sessions with Cleaned Timestamp
GO
CREATE VIEW vw_WeeklyUserSessions AS
SELECT
    user_id,
    CAST([timestamp] AS DATE) AS cohort_week_date,
    FORMAT(CAST([timestamp] AS DATETIME), 'dd-MM-yyyy') AS cohort_week,
    DATEPART(WEEK, CAST([timestamp] AS DATETIME)) AS cohort_week_number,
    COUNT(DISTINCT session_id) AS sessions
FROM FunnelCleaned
WHERE ISDATE([timestamp]) = 1
GROUP BY 
    user_id,
    CAST([timestamp] AS DATE),
    FORMAT(CAST([timestamp] AS DATETIME), 'dd-MM-yyyy'),
    DATEPART(WEEK, CAST([timestamp] AS DATETIME));



-- View 2: Cohort Retention Monitoring Summary
GO
CREATE VIEW vw_CohortRetention_Monitoring AS
SELECT 
    cohort_week,
    cohort_week_number,
    COUNT(DISTINCT user_id) AS users,
    SUM(sessions) AS total_sessions,
    ROUND(1.0 * SUM(sessions) / COUNT(DISTINCT user_id), 2) AS avg_sessions_per_user,
    COUNT(DISTINCT CASE WHEN sessions >= 2 THEN user_id END) AS users_2plus_sessions,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN sessions >= 2 THEN user_id END) * 1.0 / COUNT(DISTINCT user_id), 2) AS session_1_to_2_retention
FROM vw_WeeklyUserSessions
GROUP BY cohort_week, cohort_week_number;


    SELECT * 
FROM vw_CohortRetention_Monitoring
ORDER BY TRY_CAST(cohort_week AS DATE);


go
CREATE VIEW vw_WishlistActivationByCategory AS
WITH EligibleFavorites AS (
    SELECT 
        user_id,
        category_id
    FROM FunnelCleaned
    WHERE favorited = 1
    GROUP BY user_id, category_id
    HAVING 
        SUM(CAST(carted AS INT)) = 0 AND 
        SUM(CAST(converted AS INT)) = 0
),
CategoryFavoriteCounts AS (
    SELECT 
        category_id,
        COUNT(DISTINCT user_id) AS total_favorites
    FROM EligibleFavorites
    GROUP BY category_id
)
SELECT 
    category_id,
    total_favorites
FROM CategoryFavoriteCounts
WHERE total_favorites > 2;
SELECT TOP 1000 *
FROM vw_WishlistActivationByCategory
ORDER BY total_favorites DESC;

