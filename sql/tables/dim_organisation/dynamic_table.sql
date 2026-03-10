SELECT 
GID AS ID, 
COMMON_IDENTIFIER, 
NAME, 
RUC_CUSTOMER_NUMBER, 
LOCALE, 
TIMEZONE FROM "${source_db}".core.organisation o 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON o.GID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')
WHERE SF_INACTIVE_DATE IS NULL;