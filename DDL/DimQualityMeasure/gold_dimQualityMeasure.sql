CREATE TABLE IF NOT EXISTS claimspan.gold.gold_dimQualityMeasure (
 qualityMeasureKey  int
,measureYear  int
,qualityMeasureCode string
,qualityMeasureName string
) USING delta;