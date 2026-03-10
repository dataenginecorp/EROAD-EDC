SELECT 
gf.ID, 
gf.COMMON_IDENTIFIER_GID as GEOFENCE_MAIN_ID, 
gf.ORGANISATION_ID, 
gf.NAME, 
gf.TYPES, 
gf.GEOMETRY, 
g.SPEED_LIMIT, 
gf.ACTIVE, 
gf.ORIGIN, 
gf.VALIDFROM_DATETIME, 
gf.VALIDTO_DATETIME 
FROM "${source_db}".core_extensions.geofence gf 
INNER JOIN "${source_db}".core.geofence g 
ON gf.ID = g.ID 
AND g.SF_INACTIVE_DATE IS NULL 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON gf.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

