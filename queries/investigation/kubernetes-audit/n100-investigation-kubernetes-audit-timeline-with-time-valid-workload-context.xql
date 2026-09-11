//Title
Investigation - Kubernetes Audit Timeline with Time-Valid Workload Context

//Description
Presents response-stage Kubernetes audit events for one cluster and adds workload context only when cluster, stable object UID and inventory validity match. Keeps unmatched audit events visible and avoids assigning current workload names retrospectively to recreated objects.

//Category
Investigation / Kubernetes Audit

:Query:

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
| filter cluster_id = {{CLUSTER_TO_REVIEW}}
| filter stage in ("ResponseStarted", "ResponseComplete")
| join type = left conflict_strategy = both (
dataset = {{KUBERNETES_WORKLOAD_IDENTITY_HISTORY}}
| alter
    workload_cluster = {{WORKLOAD_CLUSTER}},
    workload_object_uid = {{WORKLOAD_OBJECT_UID}},
    workload_from = {{WORKLOAD_VALID_FROM}},
    workload_until = {{WORKLOAD_VALID_UNTIL}},
    workload_kind = {{WORKLOAD_KIND}},
    workload_name = {{WORKLOAD_NAME}},
    node_name = {{WORKLOAD_NODE_NAME}}
| fields workload_cluster, workload_object_uid, workload_from, workload_until, workload_kind, workload_name, node_name
) as w w.workload_cluster = cluster_id and w.workload_object_uid = object_uid and event_time >= w.workload_from and event_time < w.workload_until
| fields event_time, cluster_id, audit_id, stage, user_name, verb, resource, subresource, namespace, object_name, object_uid, response_code, w.workload_kind, w.workload_name, w.node_name
| sort desc event_time
| limit 1000
