SELECT 
ms.GID as ID, 
ms.ORGANISATION_ID, 
ms.MACHINE_ID, 
ms.SERVICE_TYPE_ID, 
convert_timezone(org.TIMEZONE,concat(ms.PROCESSED_DATE::string,' +0000')::timestamp_tz)::date as PROCESSED_LOCAL_DATE, 
ms.NEXT_SERVICE_ODOMETER, 
convert_timezone(org.TIMEZONE,concat(ms.NEXT_SERVICE_DATE::string,' +0000')::timestamp_tz)::date as NEXT_SERVICE_LOCAL_DATE, 
ms.NEXT_SERVICE_HOURS, 
ms.INACTIVE, 
ms.STATUS, 
ms.SF_LOAD_DATE as LOAD_DATETIME 
FROM "${source_db}".core.maintenance_service_schedule ms 
INNER JOIN "${source_db}".core.organisation org 
ON (org.GID = ms.ORGANISATION_ID AND org.SF_INACTIVE_DATE IS NULL) 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON ms.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
 WHERE ms.SF_INACTIVE_DATE IS NULL;