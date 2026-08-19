MERGE INTO DestinationTable t 
USING (
    SELECT * FROM temptableSQLScript
) s
ON s.yearNumber = t.yearNumber 
AND s.monthNumber = t.monthNumber 

WHEN NOT MATCHED THEN 
    INSERT ( 
        qualityYearMonthKey,
        monthNumber,
        monthName,
        yearNumber,
        isRunout
    ) 
    VALUES ( 
        s.qualityYearMonthKey,
        s.monthNumber,
        s.monthName,
        s.yearNumber,
        s.isRunout
    );