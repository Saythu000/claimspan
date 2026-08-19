"""
Comprehensive claims mapping for EDI 837
Provides the raw source fields needed to derive the silver_gapsincare table

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
IMPORTANT: WHY THIS MAPPING IS "SHORT" BUT THE JSON IS HUGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This mapping is a SCHEMA/TEMPLATE that defines WHERE to find each field.
It does NOT extract the actual 14,976+ records - that's done by processing code.

Example: Your JSON contains 14,976 service lines, but this mapping only shows:
  "MEDICAL_CODE": "detail.transaction_set_header_loop.transaction_set_header_SV2[].sv202_202[1]"

The [] means: "Iterate through this array in your code and extract this field from each item."

Your processing code should:
  1. Loop through transaction_set_header_SV2 (14,976 iterations)
  2. For each service line, extract MEDICAL_CODE using this path
  3. Result: 14,976 records with MEDICAL_CODE populated

This mapping expands to 14,976+ rows when applied to the data!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EDI 837 STRUCTURE: FLAT ARRAYS OF SEGMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All segments (NM1, CLM, HI, SV2, DTP, etc.) are parallel arrays.
To process all claims/services, iterate through these arrays in your processing logic.

Data Volume in Current File:
- transaction_set_header_CLM: 150 claims
- transaction_set_header_NM1: 301 name segments (patients, providers, etc.)
- transaction_set_header_HI: 150 diagnosis code segments (one per claim)
- transaction_set_header_SV2: 14,976 service line details
- transaction_set_header_DTP: 14,975 service dates (one per service line)
- transaction_set_header_LX: 14,976 service line numbers
- transaction_set_header_PRV: 150 provider taxonomy records
- transaction_set_header_N3: 151 address segments
- transaction_set_header_N4: 151 city/state/zip segments
- transaction_set_header_HL: 151 hierarchical structure records

Filtering Tips:
- NM1: Filter by entity_identifier_code='IL' for patients, '85' for billing provider
- HL: Filter by hierarchical_level_code='20' for payer, '22' for subscriber

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"""

MAPPINGS = {
    "name": "Claims Comprehensive Schema Mapping - EDI 837",
    "mapping_type": "only_mapped",
    
    "expressions": {
        # ============================================================
        # CORE PATIENT IDENTIFIERS (Links to Member Dimension)
        # NOTE: NM1 segments are in an array. Filter for entity_identifier_code='IL' 
        # to find the patient/insured records
        # ============================================================
        "MEMBER_ID": "detail.transaction_set_header_loop.transaction_set_header_NM1[].insured_id",
        "PATIENT_LAST_NAME": "detail.transaction_set_header_loop.transaction_set_header_NM1[].insured_last_name",
        "PATIENT_FIRST_NAME": "detail.transaction_set_header_loop.transaction_set_header_NM1[].insured_first_name",
        "PATIENT_ID_QUALIFIER": "detail.transaction_set_header_loop.transaction_set_header_NM1[].insured_id_qualifier",
        "ENTITY_TYPE": "detail.transaction_set_header_loop.transaction_set_header_NM1[].entity_identifier_code",
        
        # ============================================================
        # MEDICAL CODES (The HEDIS Filter Keys)
        # ============================================================
        # Procedure/billing code from service line (SV2 segment)
        # sv202_202 is an array: [qualifier, code] e.g. ['HC', '99223']
        # Index [1] gets the actual code, [0] is the qualifier (HC=HCPCS, etc.)
        "MEDICAL_CODE_QUALIFIER": "detail.transaction_set_header_loop.transaction_set_header_SV2[].sv202_202[0]",
        "MEDICAL_CODE": "detail.transaction_set_header_loop.transaction_set_header_SV2[].sv202_202[1]",
        "REVENUE_CODE": "detail.transaction_set_header_loop.transaction_set_header_SV2[].service_line_revenue_code",
        
        # Diagnosis Codes (HI segment - ICD-10 codes)
        # Each hi field is an array: [qualifier, code] e.g. ['BK', 'I10']
        # BK = Principal Diagnosis, BF = Secondary Diagnosis
        "PRINCIPAL_DIAGNOSIS_QUALIFIER": "detail.transaction_set_header_loop.transaction_set_header_HI[].hi01_01[0]",
        "PRINCIPAL_DIAGNOSIS_CODE": "detail.transaction_set_header_loop.transaction_set_header_HI[].hi01_01[1]",
        "DIAGNOSIS_CODE_2_QUALIFIER": "detail.transaction_set_header_loop.transaction_set_header_HI[].hi02_01[0]",
        "DIAGNOSIS_CODE_2": "detail.transaction_set_header_loop.transaction_set_header_HI[].hi02_01[1]",
        
        # ============================================================
        # SERVICE DATES & QUANTITIES (For Timeline Validation & PDC Math)
        # ============================================================
        # Service date from DTP segment (can be single date or range: YYYYMMDD or YYYYMMDD-YYYYMMDD)
        "SERVICE_DATE": "detail.transaction_set_header_loop.transaction_set_header_DTP[].service_date",
        
        # Service line details
        "LINE_ITEM_CHARGE": "detail.transaction_set_header_loop.transaction_set_header_SV2[].line_item_charge_amount",
        "SERVICE_UNIT_COUNT": "detail.transaction_set_header_loop.transaction_set_header_SV2[].service_unit_count_205",
        "UNIT_MEASUREMENT_CODE": "detail.transaction_set_header_loop.transaction_set_header_SV2[].unit_or_basis_for_measurement_code",
        
        # Service line number (LX segment)
        "SERVICE_LINE_NUMBER": "detail.transaction_set_header_loop.transaction_set_header_LX[].assigned_number",
        
        # ============================================================
        # OPERATIONAL CLAIMS METADATA (CLM segment)
        # ============================================================
        "CLAIM_CONTROL_NUMBER": "detail.transaction_set_header_loop.transaction_set_header_CLM[].patient_control_number",
        "TOTAL_CLAIM_CHARGE": "detail.transaction_set_header_loop.transaction_set_header_CLM[].total_charge_amount",
        "FACILITY_CODE": "detail.transaction_set_header_loop.transaction_set_header_CLM[].facility_code",
        "PLACE_OF_SERVICE": "detail.transaction_set_header_loop.transaction_set_header_CLM[].place_of_service",
        "CLAIM_FREQUENCY_CODE": "detail.transaction_set_header_loop.transaction_set_header_CLM[].frequency_code",
        "PROVIDER_SIGNATURE_IND": "detail.transaction_set_header_loop.transaction_set_header_CLM[].provider_signature_indicator",
        
        # ============================================================
        # PROVIDER INFORMATION (NM1 segments with different entity codes)
        # ============================================================
        # Entity codes: 85=Billing Provider, 71=Attending Physician, etc.
        # Filter NM1 array by entity_identifier_code to get specific provider types
        "PROVIDER_NAME": "detail.transaction_set_header_loop.transaction_set_header_NM1[].billing_provider_name",
        "PROVIDER_FIRST_NAME": "detail.transaction_set_header_loop.transaction_set_header_NM1[].first_name",
        "PROVIDER_MIDDLE_NAME": "detail.transaction_set_header_loop.transaction_set_header_NM1[].middle_name",
        "PROVIDER_PREFIX": "detail.transaction_set_header_loop.transaction_set_header_NM1[].billing_provider_prefix",
        "PROVIDER_SUFFIX": "detail.transaction_set_header_loop.transaction_set_header_NM1[].billing_provider_suffix",
        "PROVIDER_ID_QUALIFIER": "detail.transaction_set_header_loop.transaction_set_header_NM1[].billing_provider_id_qualifier",
        
        # ============================================================
        # PROVIDER TAXONOMY (PRV segment)
        # ============================================================
        "PROVIDER_CODE": "detail.transaction_set_header_loop.transaction_set_header_PRV[].provider_code",
        "PROVIDER_TAXONOMY_CODE": "detail.transaction_set_header_loop.transaction_set_header_PRV[].provider_taxonomy_code",
        "PROVIDER_REFERENCE_QUALIFIER": "detail.transaction_set_header_loop.transaction_set_header_PRV[].reference_identification_qualifier_02",
        
        # ============================================================
        # PROVIDER ADDRESS (N3/N4 segments)
        # ============================================================
        "PROVIDER_ADDRESS_LINE_1": "detail.transaction_set_header_loop.transaction_set_header_N3[].attending_physician_address_line_1",
        "PROVIDER_CITY": "detail.transaction_set_header_loop.transaction_set_header_N4[].attending_physician_city",
        "PROVIDER_STATE": "detail.transaction_set_header_loop.transaction_set_header_N4[].attending_physician_state",
        "PROVIDER_ZIP_CODE": "detail.transaction_set_header_loop.transaction_set_header_N4[].attending_physician_zip_code",
        
        # ============================================================
        # REFERENCE IDENTIFIERS (REF segment)
        # ============================================================
        "EMPLOYER_ID": "detail.transaction_set_header_loop.transaction_set_header_REF[].employer_id",
        
        # ============================================================
        # DURABLE MEDICAL EQUIPMENT (DM segment)
        # ============================================================
        "DME_FIELD_01": "detail.transaction_set_header_loop.transaction_set_header_DM[].dm01",
        "DME_FIELD_02": "detail.transaction_set_header_loop.transaction_set_header_DM[].dm02_02",
        "DME_FIELD_03": "detail.transaction_set_header_loop.transaction_set_header_DM[].dm03_03",
        
        # ============================================================
        # HIERARCHICAL STRUCTURE (HL segment)
        # Level codes: 20=Information Source, 22=Subscriber
        # ============================================================
        "HIERARCHICAL_ID": "detail.transaction_set_header_loop.transaction_set_header_HL[].hierarchical_id_number",
        "HIERARCHICAL_PARENT_ID": "detail.transaction_set_header_loop.transaction_set_header_HL[].hierarchical_parent_id_number_02",
        "HIERARCHICAL_LEVEL_CODE": "detail.transaction_set_header_loop.transaction_set_header_HL[].hierarchical_level_code",
    }
}