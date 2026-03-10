SELECT 
soe.ID, 
soe.ORGANISATION_ID, 
soe.MACHINE_ID, 
soe.MACHINE_ACTIVATION_ID, 
soe.DRIVER_ID, 
soe.EVENT_DATETIME, 
soe.EVENT_LOCAL_DATETIME, 
soe.EVENT_DATE as EVENT_LOCAL_DATE, 
soe.LONGITUDE, 
soe.LATITUDE, 
soe.SPEED, 
soe.ODOMETER_TOTAL, 
soe.SPEED_LIMIT, 
soe.SPEED_BAND, 
soe.LOCATION, 
soe.SESSION_ID, 
soe.GOOGLE_MAPS_URL, 
soe.SHARED_MACHINE, 
soe.LOAD_DATE as LOAD_DATETIME 
FROM "${source_db}".core_extensions.shared_overspeed_event_union soe 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON soe.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');