CREATE TABLE IF NOT EXISTS claimspan.silver.silver_memberpersonbridge (
  ESAIInternalPersonID string
, IsCurrent int
, UniqueRecord string
, FileLayoutID int
, FileID bigint
, name_family string
, name_given_first string
, birthDate string
, gender string
, address_permanent_line1 string
, telecom_phone_home string
, identifier_planMemberID string
, identifier_beneficiaryID string
, identifier_enrolleeUniqueID string
, hashKey string
, IsCurrentPlanMemberID int
, IsCurrentUniquePersonKey int
, IsOriginalMemberID int
, PMUP string
, IsCurrentPMUP int
) USING delta;
