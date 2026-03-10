SELECT 
am.ID, 
am.ORGANISATION_ID, 
MAKE, 
MODEL, 
VIN, 
MACHINE_TYPE, 
YEAR_OF_MANUFACTURE, 
VEHICLE_WEIGHT_TYPE, 
IS_RUC_VEHICLE, 
AXLE_COUNT, 
FUEL_TYPE, 
CURRENTLY_ACTIVE, 
ACTIVE_REGISTRATION_PLATE, 
ACTIVE_DISPLAY_NAME, 
ACTIVE_ASSET_CODE, 
am.COST_CENTER AS ACTIVE_COST_CENTER, 
ohm.TIMEZONE, 
FALSE as IS_SHARED 
FROM "${source_db}".core_extensions.all_machine am 
LEFT JOIN "${source_db}".core.organisation_has_machines ohm 
ON am.ID = ohm.MACHINE_ID 
and am.ORGANISATION_ID = ohm.ORGANISATION_ID 
and ohm.END_DATE is null 
and ohm.SF_INACTIVE_DATE is null 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON am.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}')

UNION

SELECT 
asm.ID, 
asm.ORGANISATION_ID, 
MAKE, 
MODEL, 
VIN, 
MACHINE_TYPE, 
YEAR_OF_MANUFACTURE, 
VEHICLE_WEIGHT_TYPE, 
IS_RUC_VEHICLE, 
AXLE_COUNT, 
FUEL_TYPE, 
CURRENTLY_ACTIVE, 
ACTIVE_REGISTRATION_PLATE, 
ACTIVE_DISPLAY_NAME, 
ACTIVE_ASSET_CODE, 
asm.COST_CENTER AS ACTIVE_COST_CENTER, 
ohm.TIMEZONE, 
TRUE as IS_SHARED 
FROM "${source_db}".core_extensions.all_shared_machine asm 
LEFT JOIN "${source_db}".core.organisation_has_machines ohm 
ON asm.ID = ohm.MACHINE_ID 
AND asm.ORGANISATION_ID = ohm.ORGANISATION_ID 
AND ohm.END_DATE is null 
AND ohm.SF_INACTIVE_DATE is null 
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON asm.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');
