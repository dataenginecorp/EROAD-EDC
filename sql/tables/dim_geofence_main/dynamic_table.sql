SELECT 
ID, 
gfc.ORGANISATION_ID, 
NAME, 
TYPES, 
GEOMETRY, 
ACTIVE 
FROM "${source_db}".core_extensions.geofence_common gfc 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON gfc.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

