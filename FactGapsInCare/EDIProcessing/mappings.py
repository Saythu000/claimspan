"""
Claims mapping definition (EDI 837)
Updated to match flat submitter_NM1_loop JSON parser structure.
"""

MAPPINGS = {
    "name": "Claims Comprehensive Schema Mapping",
    "mapping_type": "only_mapped",
    
    "expressions": {
        # ============================================================
        # CLAIM IDENTIFIERS & HEADER
        # ============================================================
        "CLAIM_ID": "detail.submitter_NM1_loop.transaction_set_header_CLM.patient_control_number",
        "TOTAL_CLAIM_CHARGE": "detail.submitter_NM1_loop.transaction_set_header_CLM.total_charge_amount",
        "CLAIM_TYPE": "detail.submitter_NM1_loop.transaction_set_header_CLM.facility_code",
        "FACILITY_TYPE_CODE": "detail.submitter_NM1_loop.transaction_set_header_CLM.facility_code",
        "CLAIM_FREQUENCY_CODE": "detail.submitter_NM1_loop.transaction_set_header_CLM.frequency_code",
        "PATIENT_SIGNATURE_SOURCE": "detail.submitter_NM1_loop.transaction_set_header_CLM.provider_signature_indicator",
        "ASSIGNMENT_BENEFITS_INDICATOR": "detail.submitter_NM1_loop.transaction_set_header_CLM.assignment_participation_code",
        "RELEASE_OF_INFORMATION_CODE": "detail.submitter_NM1_loop.transaction_set_header_CLM.release_of_information_code",
        
        # ============================================================
        # PATIENT / MEMBER DEMOGRAPHICS
        # ============================================================
        "PATIENT_ID": "detail.submitter_NM1_loop.transaction_set_header_NM1[3].insured_id",
        "PATIENT_LAST_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[3].insured_last_name",
        "PATIENT_FIRST_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[3].insured_first_name",
        "PATIENT_GENDER": "detail.submitter_NM1_loop.transaction_set_header_DMG[0].patient_gender_code",
        "PATIENT_DOB": "detail.submitter_NM1_loop.transaction_set_header_DMG[0].patient_birth_date",
        
        # Subscriber Info
        "SUBSCRIBER_ID": "detail.submitter_NM1_loop.transaction_set_header_NM1[3].insured_id",
        "SUBSCRIBER_LAST_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[3].insured_last_name",
        "SUBSCRIBER_FIRST_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[3].insured_first_name",
        
        # ============================================================
        # DATES OF SERVICE
        # ============================================================
        "SERVICE_START_DATE": "detail.submitter_NM1_loop.transaction_set_header_DTP[1].service_date",
        "SERVICE_END_DATE": "detail.submitter_NM1_loop.transaction_set_header_DTP[1].service_date",
        "STATEMENT_DATE_RANGE": "detail.submitter_NM1_loop.transaction_set_header_DTP[0].statement_date",
        
        # ============================================================
        # DIAGNOSIS CODES (HI Loop)
        # ============================================================
        "PRIMARY_DIAGNOSIS_CODE": "detail.submitter_NM1_loop.transaction_set_header_HI[0].hi01_01[1]",
        "DIAGNOSIS_CODE_2": "detail.submitter_NM1_loop.transaction_set_header_HI[0].hi02_01[1]",
        "DIAGNOSIS_CODE_3": "detail.submitter_NM1_loop.transaction_set_header_HI[0].hi03_01[1]",
        
        # ============================================================
        # SERVICE LINE INFORMATION (First line item / array index 0)
        # ============================================================
        "LINE_ITEM_CONTROL_NUMBER": "detail.submitter_NM1_loop.transaction_set_header_LX[0].assigned_number",
        "PROCEDURE_QUALIFIER": "detail.submitter_NM1_loop.transaction_set_header_SV1[0].sv101_101[0]",
        "PROCEDURE_CODE": "detail.submitter_NM1_loop.transaction_set_header_SV1[0].sv101_101[1]",
        "LINE_CHARGE_AMOUNT": "detail.submitter_NM1_loop.transaction_set_header_SV1[0].line_item_charge_amount",
        "SERVICE_UNIT_COUNT": "detail.submitter_NM1_loop.transaction_set_header_SV1[0].service_unit_count_104",
        "UNIT_OF_MEASURE": "detail.submitter_NM1_loop.transaction_set_header_SV1[0].unit_or_basis_for_measurement_code",
        "LINE_SERVICE_DATE": "detail.submitter_NM1_loop.transaction_set_header_DTP[1].service_date",
        
        # ============================================================
        # PROVIDER INFORMATION
        # ============================================================
        "BILLING_PROVIDER_NPI": "detail.submitter_NM1_loop.transaction_set_header_NM1[2].billing_provider_id",
        "BILLING_PROVIDER_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[2].billing_provider_name",
        "RENDERING_PROVIDER_NPI": "detail.submitter_NM1_loop.transaction_set_header_NM1[5].rendering_provider_id",
        "RENDERING_PROVIDER_LAST_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[5].rendering_provider_last_name",
        "RENDERING_PROVIDER_FIRST_NAME": "detail.submitter_NM1_loop.transaction_set_header_NM1[5].rendering_provider_first_name"
    }
}