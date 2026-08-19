CREATE OR REPLACE TABLE claimspan.gold.gold_dimclient (
 clientKey  int
,clientCode  string
,clientName  string
,subClientCode  string
,subClientName  string
) USING delta;

