SELECT DISTINCT 
s.ID, 
ASSET_ID AS MACHINE_ID, 
TYPE AS CODE, 
GROUP_NAME AS "GROUP", 
SOURCE_NAME AS "SOURCE", 
SUBJECT_NAME AS DESCRIPTION 
FROM "${source_db}".core_extensions.ecm_sensor s 
INNER JOIN "${source_db}".core_extensions.shared_machine_activations_union smau 
ON smau.MACHINE_ID=s.ASSET_ID 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON smau.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');

