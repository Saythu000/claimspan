MERGE INTO DestinationTable t 
USING (
    SELECT * FROM temptableSQLScript
) s
ON s.measureYear = t.measureYear 
AND s.qualityMeasureCode = t.qualityMeasureCode 
AND s.qualityMeasureName = t.qualityMeasureName

WHEN NOT MATCHED THEN 
    INSERT ( 
        qualityMeasureKey,
        measureYear,
        qualityMeasureCode,
        qualityMeasureName
    ) 
    VALUES ( 
        s.qualityMeasureKey,
        s.measureYear,
        s.qualityMeasureCode,
        s.qualityMeasureName
    );