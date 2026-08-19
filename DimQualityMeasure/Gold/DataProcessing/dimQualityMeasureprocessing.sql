SELECT
    HASH(CONCAT(measureYear, '|', measureCode, '|', measureName)) AS qualityMeasureKey,
    measureYear,
    measureCode AS qualityMeasureCode,
    measureName AS qualityMeasureName
FROM (
    SELECT 
        CAST(LEFT(yearMonth, 4) AS INT) AS measureYear, 
        measureCode, 
        measureName  
    FROM GapsInCare
)
WHERE measureYear IS NOT NULL 
  AND IFNULL(measureCode, '') <> '' 
  AND IFNULL(measureName, '') <> ''

UNION

SELECT 
    -1 AS qualityMeasureKey, 
    9999 AS measureYear, 
    'UNKNOWN' AS qualityMeasureCode, 
    'UNKNOWN' AS qualityMeasureName;