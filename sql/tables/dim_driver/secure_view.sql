
SELECT 
     ID, 
    dt.ORGANISATION_ID, 
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
FROM ${edc_db}.${region_schema}.${dynamic_table} dt
 INNER JOIN ${edc_db}.${admin_schema}.${access_table} aoa
 ON CURRENT_ACCOUNT() = aoa.ACCOUNT_NAME 
 AND dt.organisation_id = aoa.organisation_id;