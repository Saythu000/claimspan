WITH ProviderHierarchy AS (
  SELECT 
     pgr.PROVIDERID AS ESAIInternalProviderID
    ,pgr.PROVIDERNPI AS identifier_npi
    ,pgr.LOCATIONTIN AS identifier_tin
    ,pgr.PROVIDERLASTNAME AS name_family
    ,CAST(NULL AS string) AS name_given_first
    ,CAST(NULL AS string) AS name_given_middle
    ,pgr.PHONENUMBER AS telecom_phone
    ,pgr.LOCATIONADDRESS1 AS address_line1
    ,pgr.LOCATIONADDRESS2 AS address_line2
    ,pgr.LOCATIONCITY AS address_city
    ,pgr.LOCATIONSTATE AS address_state
    ,pgr.LOCATIONZIP AS address_postalCode
    ,pgr.LOCATIONID AS practiceCode
    ,pgr.LOCATIONDESC AS practiceName
    ,pgr.LOCATIONTIN AS poCode
    ,pgr.TIER2DESC AS poName
    ,CASE WHEN pgr.PROVIDERNPI IS NULL THEN '' ELSE pgr.LOCATIONDESC END AS providerSpecialtyDescription
    ,CAST(NULL AS string) AS taxonomyCode1
    ,CAST(NULL AS string) AS hpSpecialtyCode1
    ,CAST(NULL AS string) AS advProviderSpecialtyCode1
    ,CAST(NULL AS string) AS taxonomyCode2
    ,CAST(NULL AS string) AS hpSpecialtyCode2
    ,CAST(NULL AS string) AS advProviderSpecialtyCode2
    ,CAST(NULL AS string) AS taxonomyCode3
    ,CAST(NULL AS string) AS hpSpecialtyCode3
    ,CAST(NULL AS string) AS advProviderSpecialtyCode3
    ,CAST(NULL AS string) AS taxonomyCode4
    ,CAST(NULL AS string) AS hpSpecialtyCode4
    ,CAST(NULL AS string) AS advProviderSpecialtyCode4
    ,CAST(NULL AS string) AS taxonomyCode5
    ,CAST(NULL AS string) AS hpSpecialtyCode5
    ,CAST(NULL AS string) AS advProviderSpecialtyCode5
    ,CAST(NULL AS string) AS extension_isPrescribePrivilege
    ,CAST(NULL AS string) AS identifier_providerDEA
    ,CAST(NULL AS string) AS identifier_payerID
    ,CAST(NULL AS string) AS extension_isContracted
    ,CAST(NULL AS string) AS extension_providerHAI
    ,CAST(NULL AS string) AS identifier_hospitalID
    ,CAST(NULL AS string) AS extension_isExcludedFromProviderReporting
    ,CAST(NULL AS string) AS identifier_alternateKey1
    ,CAST(NULL AS string) AS identifier_alternateKey2
    ,CAST(NULL AS string) AS identifier_alternateKey3
    ,CAST(NULL AS string) AS identifier_alternateKey4
    ,CAST(NULL AS string) AS identifier_alternateKey5
    ,CAST(NULL AS string) AS identifier_alternateKey6
    ,CAST(NULL AS string) AS identifier_alternateKey7
    ,CAST(NULL AS string) AS identifier_alternateKey8
    ,CAST(NULL AS string) AS identifier_alternateKey9
    ,CAST(NULL AS string) AS identifier_alternateKey10
    ,'Targeted' AS extension_programType
    ,'New - Targeted' AS extension_practiceTargetedStatus
    ,CAST(NULL AS string) AS extension_ProductID
    ,CAST(NULL AS string) AS extension_ProviderType
    ,ROW_NUMBER() OVER(PARTITION BY pgr.PROVIDERID ORDER BY pgr.STARTDATE DESC) AS RowNumber
  FROM provider_hierarchy pgr
),
ProviderHierarchyFiltered AS (
  SELECT *
  FROM ProviderHierarchy
  WHERE RowNumber = 1
),
CombinedProvider AS (
  SELECT 
     p.ESAIInternalProviderID
    ,CURRENT_DATE() AS effectiveStartDate
    ,CAST(null AS date) AS effectiveEndDate
    ,1 AS isCurrent
    ,p.identifier_npi
    ,p.identifier_tin
    ,p.name_family
    ,p.name_given_first
    ,p.name_given_middle
    ,p.telecom_phone
    ,p.address_line1
    ,p.address_line2
    ,p.address_city
    ,p.address_state
    ,p.address_postalCode
    ,p.practiceCode
    ,p.practiceName
    ,p.poCode AS providerOrgCode
    ,p.poName AS providerOrgName
    ,p.providerSpecialtyDescription
    ,p.taxonomyCode1
    ,p.hpSpecialtyCode1
    ,p.advProviderSpecialtyCode1
    ,p.taxonomyCode2
    ,p.hpSpecialtyCode2
    ,p.advProviderSpecialtyCode2
    ,p.taxonomyCode3
    ,p.hpSpecialtyCode3
    ,p.advProviderSpecialtyCode3
    ,p.taxonomyCode4
    ,p.hpSpecialtyCode4
    ,p.advProviderSpecialtyCode4
    ,p.taxonomyCode5
    ,p.hpSpecialtyCode5
    ,p.advProviderSpecialtyCode5
    ,p.extension_isPrescribePrivilege
    ,p.identifier_providerDEA
    ,p.identifier_payerID
    ,p.extension_isContracted
    ,p.extension_providerHAI
    ,p.identifier_hospitalID
    ,p.extension_isExcludedFromProviderReporting
    ,p.identifier_alternateKey1
    ,p.identifier_alternateKey2
    ,p.identifier_alternateKey3
    ,p.identifier_alternateKey4
    ,p.identifier_alternateKey5
    ,p.identifier_alternateKey6
    ,p.identifier_alternateKey7
    ,p.identifier_alternateKey8
    ,p.identifier_alternateKey9
    ,p.identifier_alternateKey10
    ,p.extension_programType
    ,p.extension_practiceTargetedStatus
    ,p.extension_ProductID
    ,p.extension_ProviderType
  FROM ProviderHierarchyFiltered p
),
FinalProvider AS (
  SELECT 
      HASH(
         IFNULL(p.ESAIInternalProviderID,""),"|"
        ,IFNULL(p.identifier_npi,""),"|"
        ,IFNULL(p.identifier_tin,""),"|"
        ,IFNULL(p.name_family,""),"|"
        ,IFNULL(p.name_given_first,""),"|"
        ,IFNULL(p.name_given_middle,""),"|"
        ,IFNULL(p.telecom_phone,""),"|"
        ,IFNULL(p.address_line1,""),"|"
        ,IFNULL(p.address_line2,""),"|"
        ,IFNULL(p.address_city,""),"|"
        ,IFNULL(p.address_state,""),"|"
        ,IFNULL(p.address_postalCode,""),"|"
        ,IFNULL(p.practiceCode,""),"|"
        ,IFNULL(p.practiceName,""),"|"
        ,IFNULL(p.providerOrgCode,""),"|"
        ,IFNULL(p.providerOrgName,""),"|"
        ,IFNULL(p.providerSpecialtyDescription,""),"|"
        ,IFNULL(p.taxonomyCode1,""),"|"
        ,IFNULL(p.hpSpecialtyCode1,""),"|"
        ,IFNULL(p.advProviderSpecialtyCode1,""),"|"
        ,IFNULL(p.taxonomyCode2,""),"|"
        ,IFNULL(p.hpSpecialtyCode2,""),"|"
        ,IFNULL(p.advProviderSpecialtyCode2,""),"|"
        ,IFNULL(p.taxonomyCode3,""),"|"
        ,IFNULL(p.hpSpecialtyCode3,""),"|"
        ,IFNULL(p.advProviderSpecialtyCode3,""),"|"
        ,IFNULL(p.taxonomyCode4,""),"|"
        ,IFNULL(p.hpSpecialtyCode4,""),"|"
        ,IFNULL(p.advProviderSpecialtyCode4,""),"|"
        ,IFNULL(p.taxonomyCode5,""),"|"
        ,IFNULL(p.hpSpecialtyCode5,""),"|"
        ,IFNULL(p.advProviderSpecialtyCode5,""),"|"
        ,IFNULL(p.extension_isPrescribePrivilege,""),"|"
        ,IFNULL(p.identifier_providerDEA,""),"|"
        ,IFNULL(p.identifier_payerID,""),"|"
        ,IFNULL(p.extension_isContracted,""),"|"
        ,IFNULL(p.extension_providerHAI,""),"|"
        ,IFNULL(p.identifier_hospitalID,""),"|"
        ,IFNULL(p.extension_isExcludedFromProviderReporting,""),"|"
        ,IFNULL(p.identifier_alternateKey1,""),"|"
        ,IFNULL(p.identifier_alternateKey2,""),"|"
        ,IFNULL(p.identifier_alternateKey3,""),"|"
        ,IFNULL(p.identifier_alternateKey4,""),"|"
        ,IFNULL(p.identifier_alternateKey5,""),"|"
        ,IFNULL(p.identifier_alternateKey6,""),"|"
        ,IFNULL(p.identifier_alternateKey7,""),"|"
        ,IFNULL(p.identifier_alternateKey8,""),"|"
        ,IFNULL(p.identifier_alternateKey9,""),"|" 
        ,IFNULL(p.identifier_alternateKey10,""),"|"
        ,IFNULL(p.extension_programType,""),"|"
        ,IFNULL(p.extension_practiceTargetedStatus,"")
        ,IFNULL(p.extension_ProductID,""),"|"
        ,IFNULL(p.extension_ProviderType,"")
     ) AS providerKey
    ,p.ESAIInternalProviderID
    ,p.effectiveStartDate
    ,p.effectiveEndDate
    ,p.isCurrent
    ,p.identifier_npi
    ,p.identifier_tin
    ,p.name_family
    ,p.name_given_first
    ,p.name_given_middle
    ,p.telecom_phone
    ,p.address_line1
    ,p.address_line2
    ,p.address_city
    ,p.address_state
    ,p.address_postalCode
    ,p.practiceCode
    ,p.practiceName
    ,p.providerOrgCode
    ,p.providerOrgName
    ,p.providerSpecialtyDescription
    ,p.taxonomyCode1
    ,p.hpSpecialtyCode1
    ,p.advProviderSpecialtyCode1
    ,p.taxonomyCode2
    ,p.hpSpecialtyCode2
    ,p.advProviderSpecialtyCode2
    ,p.taxonomyCode3
    ,p.hpSpecialtyCode3
    ,p.advProviderSpecialtyCode3
    ,p.taxonomyCode4
    ,p.hpSpecialtyCode4
    ,p.advProviderSpecialtyCode4
    ,p.taxonomyCode5
    ,p.hpSpecialtyCode5
    ,p.advProviderSpecialtyCode5
    ,p.extension_isPrescribePrivilege
    ,p.identifier_providerDEA
    ,p.identifier_payerID
    ,p.extension_isContracted
    ,p.extension_providerHAI
    ,p.identifier_hospitalID
    ,p.extension_isExcludedFromProviderReporting
    ,p.identifier_alternateKey1
    ,p.identifier_alternateKey2
    ,p.identifier_alternateKey3
    ,p.identifier_alternateKey4
    ,p.identifier_alternateKey5
    ,p.identifier_alternateKey6
    ,p.identifier_alternateKey7
    ,p.identifier_alternateKey8
    ,p.identifier_alternateKey9
    ,p.identifier_alternateKey10
    ,p.extension_programType
    ,p.extension_practiceTargetedStatus
    ,p.extension_ProductID
    ,p.extension_ProviderType
  FROM CombinedProvider p
)
SELECT * FROM FinalProvider
