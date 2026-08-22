MERGE INTO claimspan.gold.gold_ma_membergroup t 
USING (SELECT * FROM tempMemberSQLScript) s 
ON IFNULL(s.identifier_subscriberID, '|') = IFNULL(t.identifier_subscriberID, '|') 
AND IFNULL(s.identifier_beneficiaryID, '|') = IFNULL(t.identifier_beneficiaryID, '|') 
AND IFNULL(s.identifier_groupNumber, '|') = IFNULL(t.identifier_groupNumber, '|') 
WHEN MATCHED AND t.hashKey <> s.hashKey THEN UPDATE SET 
  identifier_subscriberID = s.identifier_subscriberID, 
  identifier_beneficiaryID = s.identifier_beneficiaryID, 
  identifier_cmsContractNumber = s.identifier_cmsContractNumber, 
  identifier_groupNumber = s.identifier_groupNumber, 
  extension_groupSuffix = s.extension_groupSuffix, 
  StartDate = s.StartDate, 
  EndDate = s.EndDate, 
  SourceFileID = s.SourceFileID, 
  LoadDateTime = s.LoadDateTime, 
  hashKey = s.hashKey, 
  memberGroupKey = s.memberGroupKey 
WHEN NOT MATCHED THEN INSERT (
  memberGroupKey, 
  identifier_subscriberID, 
  identifier_beneficiaryID, 
  identifier_cmsContractNumber, 
  identifier_groupNumber, 
  extension_groupSuffix, 
  StartDate, 
  EndDate, 
  SourceFileID, 
  LoadDateTime, 
  hashKey
) VALUES (
  s.memberGroupKey, 
  s.identifier_subscriberID, 
  s.identifier_beneficiaryID, 
  s.identifier_cmsContractNumber, 
  s.identifier_groupNumber, 
  s.extension_groupSuffix, 
  s.StartDate, 
  s.EndDate, 
  s.SourceFileID, 
  s.LoadDateTime, 
  s.hashKey
);
