SELECT gapsInCareID
FROM tempFactGapsInCareSQLScript 
GROUP BY gapsInCareID
HAVING COUNT(1) > 1;