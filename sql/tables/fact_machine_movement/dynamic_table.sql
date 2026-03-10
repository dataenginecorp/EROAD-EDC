SELECT 
ID, 
mm.ORGANISATION_ID, 
MACHINE_ID, 
EVENT_DATETIME, 
EVENT_LOCAL_DATETIME, 
EVENT_LOCAL_DATE, 
ODOMETER, 
LATITUDE, 
LONGITUDE, 
LOCATION, 
SPEED, 
SPEED_LIMIT, 
IS_TURNING, 
LOAD_DATE as LOAD_DATETIME 
FROM "${source_db}".core_extensions.machine_movement mm 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON mm.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');