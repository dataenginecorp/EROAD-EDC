SELECT 
se.ID as ID, 
se.ORGANISATION_ID, 
se.MACHINE_GID as MACHINE_ID, 
se.MACHINE_ACTIVATION_ID, 
se.SENSOR_GID as SENSOR_ID, 
se.EVENT_TIMESTAMP as EVENT_DATETIME, 
se.EVENT_DATE, 
se.EVENT_LOCAL_DATETIME, 
se.EVENT_LOCAL_DATE, 
dc.DATAPOINT as ECM_SENSOR_TYPE_ID, 
se.SENSOR_VALUE, 
--se.PREV_SENSOR_VALUE, 
se.SF_LOAD_DATE as LOAD_DATETIME 
FROM "${source_db}".core_extensions.ecm_sensor_generic_sensor_event se 
INNER JOIN "${source_db}".core.sensor_device_config dc 
on se.EXTERNAL_GID = dc.GID 
INNER JOIN "${source_db}".core.sensor_datapoint d 
on d.ID = dc.DATAPOINT 
INNER JOIN "${source_db}".core.sensor_device d2 
on d2.ID = dc.DEVICE 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON se.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
WHERE dc.DATAPOINT IN (2, 3, 9, 10, 11, 14, 18, 22, 28, 31, 32, 33, 34, 35, 36, 37, 41, 42, 43, 44, 45, 47, 48, 50, 54, 56, 57, 58, 59, 60, 72, 73);