CREATE OR REPLACE TABLE claimspan.silver.silver_alertgroup (
 alertGroupID  int
,alertGroupCode  string
,alertGroupDescription  string
,displayText  string
,sortOrder  int
,isActive  boolean
,hashKey  int
) USING delta; 
