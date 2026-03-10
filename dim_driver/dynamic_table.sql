SELECT 
    GID as ID, 
    dr.ORGANISATION_ID, 
    DRIVER_EXTERNAL_ID, 
    DRIVER_LICENSE_ID, 
    ALIAS_NAME, 
    FIRST_NAME, 
    LAST_NAME, 
    EMAIL, 
    MOBILE_NUMBER, 
    LICENSE_JURISDICTION, 
    TERMINAL_ID, 
    ACTIVE 
FROM"${source_db}".core.driver dr 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa
  ON dr.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
WHERE SF_INACTIVE_DATE IS NULL;
