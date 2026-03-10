SELECT 
smau.ID, 
smau.ORGANISATION_ID, 
smau.MACHINE_ID, 
smau.REGISTRATION_PLATE, 
smau.DISPLAY_NAME, 
smau.ASSET_CODE, 
smau.COST_CENTER, 
smau.ACTIVATION_START_DATETIME, 
smau.ACTIVATION_END_DATETIME, 
smau.MAKE, 
smau.MODEL, 
smau.VIN, 
smau.MACHINE_TYPE, 
smau.YEAR_OF_MANUFACTURE, 
smau.VEHICLE_WEIGHT_TYPE, 
smau.IS_RUC_VEHICLE, 
smau.AXLE_COUNT, 
smau.FUEL_TYPE, 
smau.SHARED_MACHINE, 
ohm.TIMEZONE 
FROM "${source_db}".core_extensions.shared_machine_activations_union smau 
LEFT JOIN "${source_db}".core.organisation_has_machines ohm 
ON smau.MACHINE_ID = ohm.MACHINE_ID 
AND smau.ORGANISATION_ID = ohm.ORGANISATION_ID 
AND ohm.END_DATE is null 
AND ohm.SF_INACTIVE_DATE is null
INNER JOIN "${access_db}"."${access_schema}"."${access_table}" aoa 
  ON smau.ORGANISATION_ID = aoa.ORGANISATION_ID
 AND LOWER(aoa.REGION) = LOWER('${region}')
 AND UPPER(aoa.CLOUD)  = UPPER('${cloud}');
