WITH sourceTbl AS (
    SELECT DISTINCT 
        CAST(LEFT(yearMonth, 4) AS INT) AS yearNumber,
        CAST(RIGHT(yearMonth, 2) AS INT) AS monthNumber,
        CASE RIGHT(yearMonth, 2)
            WHEN '01' THEN 'January'
            WHEN '02' THEN 'February'
            WHEN '03' THEN 'March'
            WHEN '04' THEN 'April'
            WHEN '05' THEN 'May'
            WHEN '06' THEN 'June'
            WHEN '07' THEN 'July'
            WHEN '08' THEN 'August'
            WHEN '09' THEN 'September'
            WHEN '10' THEN 'October'
            WHEN '11' THEN 'November'
            WHEN '12' THEN 'December'
            WHEN '13' THEN 'Year End (Jan. Runout)'
            WHEN '14' THEN 'Year End (Final)'
        END AS monthName,
        CASE RIGHT(yearMonth, 2)
            WHEN '13' THEN TRUE
            WHEN '14' THEN TRUE
            ELSE FALSE
        END AS isRunout
    FROM GapsInCare  
    WHERE yearMonth IS NOT NULL
)

SELECT 
    HASH(CONCAT(yearNumber, '|', monthNumber)) AS qualityYearMonthKey,
    monthNumber,
    monthName,
    yearNumber,
    isRunout 
FROM sourceTbl 
WHERE monthNumber IS NOT NULL 
  AND yearNumber IS NOT NULL 
  AND monthName IS NOT NULL

UNION 

SELECT 
    -1 AS qualityYearMonthKey,
    0 AS monthNumber,
    'UNKNOWN' AS monthName,
    9999 AS yearNumber,
    FALSE AS isRunout;