SELECT 
ID, 
dl.ORGANISATION_ID, 
DRIVER_ID, 
EFFECTIVE_DATE_LOCALISED as EFFECTIVE_LOCAL_DATE, 
CURRENT_STARS, 
ORGANISATION_RANK FROM "${source_db}".core_extensions.driver_leaderboard dl 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON dl.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');