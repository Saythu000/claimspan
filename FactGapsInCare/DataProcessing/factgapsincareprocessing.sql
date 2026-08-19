WITH SourceRaw AS (
    SELECT DISTINCT 
        gic.gapsInCareID,
        IFNULL(dimQualityYearMonth.qualityYearMonthKey, -1) AS qualityYearMonthKey,
        IFNULL(dimMember.memberKey, -1) AS memberKey,
        IFNULL(dimQualityMeasure.qualityMeasureKey, -1) AS qualityMeasureKey,
        IFNULL(dimQualityEvent.qualityEventKey, -1) AS qualityEventKey,
        gic.numerCnt,
        gic.denomCnt,
        IFNULL(dimDate1.dateKey, -1) AS dateOfServiceDateKey,
        gic.practitioner_identifier AS gapsEventProviderKey,
        gic.expectedRate,
        IFNULL(dimDate2.dateKey, -1) AS serviceNeededByDateKey,
        gic.PDC AS pdc,
        gic.lastHBVal,
        IFNULL(dimDate3.dateKey, -1) AS lastHBDateKey,
        gic.lastBPDia,
        gic.lastBPSys,
        gic.identifier_claimnumber,
        gic.hbTest   
    FROM silver_gapsincare gic
    LEFT JOIN gold_dimQualityYearMonth dimQualityYearMonth
        ON gic.yearMonth = CONCAT(dimQualityYearMonth.yearNumber, LPAD(dimQualityYearMonth.monthNumber, 2, '0'))
    LEFT JOIN gold_dimMember dimMember
        ON gic.identifier_planMemberID = dimMember.identifier_planMemberID
       AND dimMember.isCurrent = TRUE
    LEFT JOIN gold_dimQualityMeasure dimQualityMeasure
        ON gic.measurecode = dimQualityMeasure.qualityMeasureCode
       AND LEFT(gic.yearMonth, 4) = dimQualityMeasure.measureYear
       AND gic.measureName = dimQualityMeasure.qualityMeasureName
    LEFT JOIN gold_dimQualityEvent dimQualityEvent
        ON gic.eventName = dimQualityEvent.qualityEventDescription
    LEFT JOIN gold_dimDate dimDate1
        ON gic.dateOfService = dimDate1.date
    LEFT JOIN gold_dimDate dimDate2
        ON gic.serviceNeededByDate = dimDate2.date
    LEFT JOIN gold_dimDate dimDate3
        ON gic.lastHBDate = dimDate3.date
)

SELECT DISTINCT 
    gapsInCareID,
    qualityYearMonthKey,
    memberKey,
    qualityMeasureKey,
    qualityEventKey,
    numerCnt,
    denomCnt,
    dateOfServiceDateKey,
    gapsEventProviderKey,
    expectedRate,
    serviceNeededByDateKey,
    pdc,
    lastHBVal,
    lastHBDateKey,
    lastBPDia,
    lastBPSys,
    identifier_claimnumber,
    hbTest,
    SHA2(CONCAT_WS('|', 
        qualityYearMonthKey,
        memberKey,
        qualityMeasureKey,
        qualityEventKey,
        IFNULL(numerCnt, '|'),
        IFNULL(denomCnt, '|'),
        dateOfServiceDateKey,
        IFNULL(gapsEventProviderKey, '|'),
        IFNULL(expectedRate, '|'),
        serviceNeededByDateKey,
        IFNULL(pdc, '|'),
        IFNULL(lastHBVal, '|'),
        lastHBDateKey,
        IFNULL(lastBPDia, '|'),
        IFNULL(lastBPSys, '|'),
        IFNULL(identifier_claimnumber, '|'),
        IFNULL(hbTest, '|')
    ), 256) AS fullRowHash
FROM SourceRaw;