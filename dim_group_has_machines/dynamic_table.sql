SELECT 
fhm.SF_RECORD_ID as ID, 
fhm.ORGANISATION_ID, 
fhm.FLEET_ID as GROUP_ID, 
fhm.MACHINE_ID, 
IFF(fhm.VALIDFROM = '1970-01-01 00:00:00.000', null, fhm.VALIDFROM) as VALIDFROM_DATETIME, 
fhm.VALIDTO as VALIDTO_DATETIME 
FROM "${source_db}".core.fleet_has_machines_snapshot fhm 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON fhm.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

