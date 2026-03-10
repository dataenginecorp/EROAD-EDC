SELECT 
tv.ID, 
tv.ORGANISATION_ID, 
tv.CURRENT_STATE_VIOLATION_ID as LOGBOOK_VIOLATION_ID, 
tv.CREATED as CREATED_DATETIME, 
tv.CREATED_LOCAL_DATETIME, 
tv.LAST_MODIFIED as LAST_MODIFIED_DATETIME, 
tv.LAST_MODIFIED_LOCAL_DATETIME, 
tv.USERNAME, 
tv.COMMENT, 
tv.LOAD_DATETIME 
FROM "${source_db}".core_extensions.timely_violation_comments tv 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON tv.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');