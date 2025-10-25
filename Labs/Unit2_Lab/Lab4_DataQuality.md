# MGMT 467 — Prompt-Driven Lab Summary

This README summarizes the steps taken and the data quality analysis performed in the MGMT 467 Prompt-Driven Lab.

## Project Details

*   **Google Cloud Project ID:** `mgmt467-lab`
*   **Google Cloud Region:** `US` 
*   **GCS Bucket Name:**  `mgmt467-netflix-f12cd620`
*   **BigQuery Dataset Name:** `netflix`

## Data Quality Analysis Summary

### Row Counts (Before DQ)

Based on the query in cell `1bfd29b0` or `3f800dee` (Verification Prompt for Section 4), the initial row counts in the `netflix` dataset were:

*   `users`: 216300
*   `movies`: 21840 
*   `watch_history`: 2205000 
*   `recommendation_logs`: 1092000 
*   `search_logs`: 556500 
*   `reviews`: 309000 

### Duplicates (Section 5.2)

*   **Table Analyzed:** `watch_history`
*   **Duplicate Key:** `(user_id, movie_id, watch_date, device_type)`
*   **Deduplication Policy:** Kept one row per group, preferring higher `progress_percentage`, then higher `watch_duration_minutes`.
*   **Resulting Table:** `watch_history_dedup`
*   **Row Count After Deduplication:** `WATCH_HISTORY_DEDUP_ROW_COUNT` (from verification query in cell `3f800dee`)
*   **Percentage of Duplicates Removed:** `PERCENTAGE_DUPLICATES_REMOVED` % (Calculated as `(WATCH_HISTORY_RAW_ROW_COUNT - WATCH_HISTORY_DEDUP_ROW_COUNT) / WATCH_HISTORY_RAW_ROW_COUNT * 100`)

### Outliers (Section 5.3)

*   **Column Analyzed:** `watch_duration_minutes` in `watch_history_dedup`
*   **Outlier Detection Method:** IQR (1.5 \* IQR below Q1 or above Q3)
*   **Percentage of IQR Outliers:** `IQR_OUTLIER_PERCENTAGE` % (from cell `ymW-Iu4YxCF6`)
*   **Outlier Handling Method:** Winsorized/Capped at P01 and P99
*   **Resulting Table:** `watch_history_robust`
*   **Min/Median/Max Before Capping:** Min=`MIN_BEFORE`, Median=`MEDIAN_BEFORE`, Max=`MAX_BEFORE` (from cell `i8fKmzefxc3S`)
*   **Min/Median/Max After Capping:** Min=`MIN_AFTER`, Median=`MEDIAN_AFTER`, Max=`MAX_AFTER` (from cell `i8fKmzefxc3S`)

### Business Anomaly Flags (Section 5.4)

*   **Flag Summaries:** (from verification query in cell `6QpbUXtizFih`)
    *   `flag_binge` (> 8 hours watch duration): `BINGE_PCT` %
    *   `flag_age_extreme` (< 10 or > 100 years old): `AGE_EXTREME_PCT` %
    *   `flag_duration_anomaly` (movie duration < 15 or > 480 min): `DURATION_ANOMALY_PCT` %
