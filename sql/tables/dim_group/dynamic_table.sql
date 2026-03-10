SELECT 
GID as ID, 
f.ORGANISATION_ID, 
NAME, 
IFF(f.VALIDFROM = '1970-01-01 00:00:00.000', null, f.VALIDFROM) as VALIDFROM_DATETIME, 
f.VALIDTO as VALIDTO_DATETIME 
FROM "${source_db}".core.fleet_snapshot f 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON f.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

