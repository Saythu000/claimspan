SELECT 
  HASH(CONCAT_WS('|', IFNULL(mg.SubscriberID, ''), IFNULL(mg.BeneficiaryID, ''), IFNULL(mg.GroupNumber, ''))) AS memberGroupKey, 
  mg.SubscriberID, 
  mg.BeneficiaryID, 
  mg.CMSContractNumber, 
  mg.GroupNumber, 
  mg.GroupSuffix, 
  mg.StartDate, 
  mg.EndDate, 
  mg.SourceFileID, 
  mg.LoadDateTime, 
  mg.hashKey 
FROM member_group mg
