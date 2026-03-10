SELECT ter.ID, 
ter.ORGANISATION_ID, 
DRIVER_ID, 
EVENT_DATE as RECORD_LOCAL_DATE, 
TOTAL_HOURS_WORKED_SECONDS as HOURS_WORKED_SECONDS, 
CUMULATIVE_PERIOD_SECONDS, 
TOTAL_DISTANCE as DISTANCE, 
TOTAL_EDITS as EDITS, 
SF_LOAD_DATE as LOAD_DATETIME 
FROM "${source_db}".core.timely_event_records ter 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON ter.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');