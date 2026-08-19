CREATE TABLE IF NOT EXISTS claimspan.gold.factgapsincare (
  gapsInCareID BIGINT
, qualityYearMonthKey BIGINT
, memberKey BIGINT
, qualityMeasureKey INT
, qualityEventKey INT
, numerCnt INT
, denomCnt INT
, dateOfServiceDateKey INT
, gapsEventProviderKey STRING
, planProviderKey INT
, providerNPIKey STRING
, expectedRate STRING
, serviceNeededByDateKey INT
, pdc STRING
, lastHBVal STRING
, lastHBDateKey INT
, lastBPDia INT
, lastBPSys INT
, identifier_claimNumber STRING
, hbTest INT
, fullRowHash STRING
) USING delta;