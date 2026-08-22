CREATE TABLE IF NOT EXISTS claimspan.gold.gold_ma_membergroup (
    memberGroupKey               STRING,
    identifier_subscriberID      STRING,
    identifier_beneficiaryID     STRING,
    identifier_cmsContractNumber STRING,
    identifier_groupNumber       STRING,
    extension_groupSuffix        STRING,
    StartDate                    DATE,
    EndDate                      DATE,
    SourceFileID                 BIGINT,
    LoadDateTime                 TIMESTAMP,
    hashKey                      STRING
) USING delta;