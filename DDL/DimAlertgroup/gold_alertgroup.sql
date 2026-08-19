CREATE OR REPLACE TABLE claimspan.gold.gold_dimalertgroup(
 alertGroupKey  int
,alertGroupCode  string
,alertGroupDescription  string
,displayText  string
,sortOrder  int
,isActive  boolean
) USING delta;