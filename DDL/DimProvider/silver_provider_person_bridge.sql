CREATE OR REPLACE TABLE claimspan.silver.silver_providerpersonbridge (
    ESAIInternalProviderID string,
    isCurrent string,
    uniqueRecord string,
    fileLayoutID int,
    fileID bigint,
    name_family string,
    name_given_first string,
    identifier_npi string,
    identifier_providerDEA string,
    identifier_payerID string,
    identifier_providerID string,
    hashKey string,
    isCurrentProviderID bigint,
    isCurrentNPI bigint,
    isOriginalProviderID int,
    pmup string,
    isCurrentPMUP int
) USING delta;