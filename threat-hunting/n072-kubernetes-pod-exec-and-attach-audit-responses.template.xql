// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{KUBERNETES_AUDIT_DATASET}}
| alter event_time = {{KUBERNETES_EVENT_TIME}}, cluster_id = {{KUBERNETES_CLUSTER_ID}}, event_json = {{KUBERNETES_EVENT_JSON}}
| alter audit_id = json_extract_scalar(event_json, "$.auditID"),
    stage = json_extract_scalar(event_json, "$.stage"),
    verb = json_extract_scalar(event_json, "$.verb"),
    user_name = json_extract_scalar(event_json, "$.user.username"),
    namespace = json_extract_scalar(event_json, "$.objectRef.namespace"),
    resource = json_extract_scalar(event_json, "$.objectRef.resource"),
    subresource = json_extract_scalar(event_json, "$.objectRef.subresource"),
    object_name = json_extract_scalar(event_json, "$.objectRef.name"),
    object_uid = json_extract_scalar(event_json, "$.objectRef.uid"),
    response_code = to_integer(json_extract_scalar(event_json, "$.responseStatus.code"))
| filter resource = "pods" and subresource in ("exec", "attach")
| filter stage in ("ResponseStarted", "ResponseComplete")
// Streaming protocol upgrades can report 101; retain raw code instead of inventing a session-success flag.
| alter request_uri = json_extract_scalar(event_json, "$.requestURI")
| fields event_time, cluster_id, audit_id, stage, user_name, namespace, object_name, object_uid, verb, subresource, response_code, request_uri
| sort desc event_time
| limit 1000
