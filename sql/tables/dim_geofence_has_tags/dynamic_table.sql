SELECT 
g.ORGANISATION_ID, 
GEOFENCE_ID, 
TAG_CATEGORY_NAME as TAG_CATEGORY, 
TAG_VALUE as TAG_NAME 
FROM "${source_db}".core_extensions.geofence_has_tag ght 
INNER JOIN "${source_db}".core_extensions.geofence g 
ON g.ID = ght.GEOFENCE_ID 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON g.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

