SELECT DISTINCT
  ID,
  DETECTION_TYPE,
  SEVERITY
FROM "${source_db}".core.media_service_detection_tag