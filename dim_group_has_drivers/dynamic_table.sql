SELECT 
dhf.SF_RECORD_ID as ID, 
dhf.ORGANISATION_ID, 
dhf.DRIVER_ID, 
dhf.FLEET_ID as GROUP_ID, 
IFF(dhf.VALIDFROM = '1970-01-01 00:00:00.000', null, dhf.VALIDFROM) as VALIDFROM_DATETIME, 
dhf.VALIDTO as VALIDTO_DATETIME 
FROM "${source_db}".core.driver_has_fleet_snapshot dhf 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON dhf.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

