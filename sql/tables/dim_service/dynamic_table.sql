SELECT 
DISTINCT st.ID, 
st.ORGANISATION_ID, 
st.NAME, 
st.DESCRIPTION 
FROM "${source_db}".core.maintenance_service_type st 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON st.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
WHERE st.ORGANISATION_ID IS NOT NULL 
UNION ALL 
SELECT DISTINCT 
ast.ID, 
aoa.ORGANISATION_ID, 
ast.NAME, 
ast.DESCRIPTION 
FROM "${source_db}".core.maintenance_service_type ast 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON ast.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
INNER JOIN "${source_db}".core.organisation org 
ON (org.GID = aoa.ORGANISATION_ID and org.ADDRESS_COUNTRY = ast.COUNTRY) 
WHERE ast.ORGANISATION_ID IS NULL AND ast.COUNTRY IS NOT NULL AND org.ADDRESS_COUNTRY IS NOT NULL;