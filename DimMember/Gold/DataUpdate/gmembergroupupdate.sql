MERGE INTO claimspan.gold.gold_ma_membergroup t 
USING (SELECT * FROM tempSQLScript) s 
ON IFNULL(s.SubscriberID, '|') = IFNULL(t.SubscriberID, '|') 
AND IFNULL(s.BeneficiaryID, '|') = IFNULL(t.BeneficiaryID, '|') 
AND IFNULL(s.GroupNumber, '|') = IFNULL(t.GroupNumber, '|') 
WHEN MATCHED AND t.hashKey <> s.hashKey THEN UPDATE SET 
  SubscriberID = s.SubscriberID, 
  BeneficiaryID = s.BeneficiaryID, 
  CMSContractNumber = s.CMSContractNumber, 
  GroupNumber = s.GroupNumber, 
  GroupSuffix = s.GroupSuffix, 
  StartDate = s.StartDate, 
  EndDate = s.EndDate, 
  SourceFileID = s.SourceFileID, 
  LoadDateTime = s.LoadDateTime, 
  hashKey = s.hashKey, 
  memberGroupKey = s.memberGroupKey 
WHEN NOT MATCHED THEN INSERT (
  memberGroupKey, 
  SubscriberID, 
  BeneficiaryID, 
  CMSContractNumber, 
  GroupNumber, 
  GroupSuffix, 
  StartDate, 
  EndDate, 
  SourceFileID, 
  LoadDateTime, 
  hashKey
) VALUES (
  s.memberGroupKey, 
  s.SubscriberID, 
  s.BeneficiaryID, 
  s.CMSContractNumber, 
  s.GroupNumber, 
  s.GroupSuffix, 
  s.StartDate, 
  s.EndDate, 
  s.SourceFileID, 
  s.LoadDateTime, 
  s.hashKey
);
