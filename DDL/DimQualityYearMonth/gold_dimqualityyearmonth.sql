CREATE TABLE IF NOT EXISTS claimsprocessing.gold.gold_dimqualityyearmonth (
 qualityYearMonthKey  int
,monthNumber  int
,monthName string
,yearNumber int
,isRunout boolean
) USING delta;