-- Data Quality Queries Exported from Colab Notebook

-- Query 1
WITH base AS (  SELECT COUNT(*) n,         COUNTIF(country IS NULL) miss_country,         COUNTIF(subscription_plan IS NULL) miss_plan,         COUNTIF(age IS NULL) miss_age  FROM `netflix.users`)SELECT n,       ROUND(100*miss_country/n,2) AS pct_missing_country,       ROUND(100*miss_plan/n,2)   AS pct_missing_subscription_plan,       ROUND(100*miss_age/n,2)    AS pct_missing_ageFROM base;

-- Query 2
SELECT country,       COUNT(*) AS n,       ROUND(100*COUNTIF(subscription_plan IS NULL)/COUNT(*),2) AS pct_missing_subscription_planFROM `netflix.users`GROUP BY countryORDER BY pct_missing_subscription_plan DESC;

-- Query 3
WITH Missingness AS (  SELECT COUNT(*) n,         COUNTIF(country IS NULL) miss_country,         COUNTIF(subscription_plan IS NULL) miss_plan,         COUNTIF(age IS NULL) miss_age  FROM `netflix.users`)SELECT ROUND(100*miss_country/n, 2) AS pct_missing_country,       ROUND(100*miss_plan/n, 2)   AS pct_missing_subscription_plan,       ROUND(100*miss_age/n, 2)    AS pct_missing_ageFROM Missingness;

-- Query 4
FROM `{PROJECT_ID}.netflix.watch_history`GROUP BY user_id, movie_id, watch_date, device_typeHAVING dup_count > 1ORDER BY dup_count DESCLIMIT 20;

-- Query 5
SELECT * EXCEPT(rk) FROM (  SELECT h.*,         ROW_NUMBER() OVER (           PARTITION BY user_id, movie_id, watch_date, device_type           ORDER BY progress_percentage DESC, watch_duration_minutes DESC         ) AS rk  FROM `{PROJECT_ID}.netflix.watch_history` h)WHERE rk = 1;

-- Query 6
(SELECT COUNT(*) FROM `{PROJECT_ID}.netflix.watch_history`) AS raw_count,  (SELECT COUNT(*) FROM `{PROJECT_ID}.netflix.watch_history_dedup`) AS deduped_count

-- Query 7
SELECT    APPROX_QUANTILES(watch_duration_minutes, 4)[OFFSET(1)] AS q1,    APPROX_QUANTILES(watch_duration_minutes, 4)[OFFSET(3)] AS q3  FROM `{PROJECT_ID}.netflix.watch_history_dedup`),bounds AS (  SELECT q1, q3, (q3-q1) AS iqr,         q1 - 1.5*(q3-q1) AS lo,         q3 + 1.5*(q3-q1) AS hi  FROM dist)SELECT  COUNTIF(h.watch_duration_minutes < b.lo OR h.watch_duration_minutes > b.hi) AS outliers,  COUNT(*) AS total,  ROUND(100*COUNTIF(h.watch_duration_minutes < b.lo OR h.watch_duration_minutes > b.hi)/COUNT(*),2) AS pct_outliersFROM `{PROJECT_ID}.netflix.watch_history_dedup` hCROSS JOIN bounds b;

-- Query 8
WITH q AS (  SELECT    APPROX_QUANTILES(watch_duration_minutes, 100)[OFFSET(1)]  AS p01,    APPROX_QUANTILES(watch_duration_minutes, 100)[OFFSET(98)] AS p99  FROM `{PROJECT_ID}.netflix.watch_history_dedup`)SELECT  h.*,  GREATEST(q.p01, LEAST(q.p99, h.watch_duration_minutes)) AS watch_duration_minutes_cappedFROM `{PROJECT_ID}.netflix.watch_history_dedup` h, q;

-- Query 9
SELECT 'before' AS which, APPROX_QUANTILES(watch_duration_minutes, 5) AS q  FROM `{PROJECT_ID}.netflix.watch_history_dedup`),after AS (  SELECT 'after' AS which, APPROX_QUANTILES(watch_duration_minutes_capped, 5) AS q  FROM `{PROJECT_ID}.netflix.watch_history_robust`)SELECT * FROM beforeUNION ALLSELECT * FROM after;

-- Query 10
SELECT    'before' AS which,    MIN(watch_duration_minutes) AS min_duration,    APPROX_QUANTILES(watch_duration_minutes, 2)[OFFSET(1)] AS median_duration,    MAX(watch_duration_minutes) AS max_duration  FROM `{PROJECT_ID}.netflix.watch_history_dedup`),after AS (  SELECT    'after' AS which,    MIN(watch_duration_minutes_capped) AS min_duration,    APPROX_QUANTILES(watch_duration_minutes_capped, 2)[OFFSET(1)] AS median_duration,    MAX(watch_duration_minutes_capped) AS max_duration  FROM `{PROJECT_ID}.netflix.watch_history_robust`)SELECT * FROM beforeUNION ALLSELECT * FROM after;

-- Query 11
SELECT    APPROX_QUANTILES(watch_duration_minutes, 4)[OFFSET(1)] AS q1,    APPROX_QUANTILES(watch_duration_minutes, 4)[OFFSET(3)] AS q3  FROM `{PROJECT_ID}.netflix.watch_history_dedup`),bounds AS (  SELECT q1, q3, (q3-q1) AS iqr,         q1 - 1.5*(q3-q1) AS lo,         q3 + 1.5*(q3-q1) AS hi  FROM dist)SELECT  COUNTIF(h.watch_duration_minutes < b.lo OR h.watch_duration_minutes > b.hi) AS outliers,  COUNT(*) AS total,  ROUND(100*COUNTIF(h.watch_duration_minutes < b.lo OR h.watch_duration_minutes > b.hi)/COUNT(*),2) AS pct_outliersFROM `{PROJECT_ID}.netflix.watch_history_dedup` hCROSS JOIN bounds b;

-- Query 12
WITH q AS (  SELECT    APPROX_QUANTILES(watch_duration_minutes, 100)[OFFSET(1)]  AS p01,    APPROX_QUANTILES(watch_duration_minutes, 100)[OFFSET(98)] AS p99  FROM `{PROJECT_ID}.netflix.watch_history_dedup`)SELECT  h.*,  GREATEST(q.p01, LEAST(q.p99, h.watch_duration_minutes)) AS watch_duration_minutes_cappedFROM `{PROJECT_ID}.netflix.watch_history_dedup` h, q;

-- Query 13
SELECT 'before' AS which, APPROX_QUANTILES(watch_duration_minutes, 5) AS q  FROM `{PROJECT_ID}.netflix.watch_history_dedup`),after AS (  SELECT 'after' AS which, APPROX_QUANTILES(watch_duration_minutes_capped, 5) AS q  FROM `{PROJECT_ID}.netflix.watch_history_robust`)SELECT * FROM beforeUNION ALLSELECT * FROM after;

-- Query 14
SELECT    'before' AS which,    MIN(watch_duration_minutes) AS min_duration,    APPROX_QUANTILES(watch_duration_minutes, 2)[OFFSET(1)] AS median_duration,    MAX(watch_duration_minutes) AS max_duration  FROM `{PROJECT_ID}.netflix.watch_history_dedup`),after AS (  SELECT    'after' AS which,    MIN(watch_duration_minutes_capped) AS min_duration,    APPROX_QUANTILES(watch_duration_minutes_capped, 2)[OFFSET(1)] AS median_duration,    MAX(watch_duration_minutes_capped) AS max_duration  FROM `{PROJECT_ID}.netflix.watch_history_robust`)SELECT * FROM beforeUNION ALLSELECT * FROM after;

