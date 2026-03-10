SELECT 
tv.ID, 
tv.ORGANISATION_ID, 
DRIVER_ID, 
KIND, 
RULE, 
RULE_NAME, 
DURATION_SECONDS, 
DURATION, 
START_TIME as START_DATETIME, 
convert_timezone(org.TIMEZONE, concat(START_TIME::string, ' +0000')::timestamp_tz ) as START_LOCAL_DATETIME, 
convert_timezone(org.TIMEZONE, concat(START_TIME::string, ' +0000')::timestamp_tz )::date as START_LOCAL_DATE, 
DRIVER_COMMENT, 
tv.SF_LOAD_DATE AS LOAD_DATETIME, 
IS_DELETED 
FROM "${source_db}".core.timely_violation tv 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON tv.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
INNER JOIN "${source_db}".core.organisation org ON (org.GID = tv.ORGANISATION_ID AND org.SF_INACTIVE_DATE IS NULL) 
WHERE tv.SF_INACTIVE_DATE IS NULL;
