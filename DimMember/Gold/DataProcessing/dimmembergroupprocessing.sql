SELECT 
  HASH(CONCAT_WS('|', IFNULL(mg.identifier_subscriberID, ''), IFNULL(mg.identifier_beneficiaryID, ''), IFNULL(mg.identifier_groupNumber, ''))) AS memberGroupKey, 
  mg.identifier_subscriberID, 
  mg.identifier_beneficiaryID, 
  mg.CMSContractNumber AS identifier_cmsContractNumber, 
  mg.GroupNumber AS identifier_groupNumber, 
  mg.GroupSuffix AS extension_groupSuffix, 
  mg.StartDate, 
  mg.EndDate, 
  mg.SourceFileID, 
  mg.LoadDateTime, 
  mg.hashKey 
FROM member_group mg
