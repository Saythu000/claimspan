CREATE TABLE IF NOT EXISTS claimspan.gold.gold_dimhcc (
 HCCNumber  string
,HCCDescription  string
,HCCVersion  string
,HCCType  string
,IsChronic  boolean
,EffectiveYear  int
,EffectiveDateStart date
,EffectiveDateEnd date
,hashKey  int
,hccKey  int
) USING delta;