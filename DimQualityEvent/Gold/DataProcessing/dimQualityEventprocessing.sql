SELECT 
    HASH(eventName) AS qualityEventKey, 
    eventName AS qualityEventDescription
FROM GapsInCare
WHERE eventName IS NOT NULL 
  AND eventName <> ''

UNION

SELECT 
    -1 AS qualityEventKey, 
    'UNKNOWN' AS qualityEventDescription