//Title
Threat Hunting - Kubernetes Bindings to Reviewed Privileged Roles

//Description
Finds successful binding changes whose admitted role reference resolves to a reviewed privileged role at event time. Uses cluster, role kind, name and namespace scope explicitly; request patches and role names alone do not establish effective privileges.

//Category
Threat Hunting / Kubernetes RBAC

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
| filter resource in ("rolebindings", "clusterrolebindings") and verb in ("create", "update", "patch")
| filter stage = "ResponseComplete" and response_code >= 200 and response_code < 300
| alter role_kind = json_extract_scalar(event_json, "$.responseObject.roleRef.kind"),
    role_name = json_extract_scalar(event_json, "$.responseObject.roleRef.name"),
    binding_uid = json_extract_scalar(event_json, "$.responseObject.metadata.uid")
| filter role_kind != null and role_name != null
| join type = inner conflict_strategy = both (
dataset = {{KUBERNETES_REVIEWED_ROLE_HISTORY}}
| alter
    role_cluster = {{ROLE_REVIEW_CLUSTER}},
    review_role_kind = {{ROLE_REVIEW_KIND}},
    review_role_name = {{ROLE_REVIEW_NAME}},
    review_role_namespace = {{ROLE_REVIEW_NAMESPACE}},
    role_from = {{ROLE_REVIEW_FROM}},
    role_until = {{ROLE_REVIEW_UNTIL}},
    high_privilege = {{ROLE_REVIEW_HIGH_PRIVILEGE}},
    role_reason = {{ROLE_REVIEW_REASON}}
| filter high_privilege = true
| fields role_cluster, review_role_kind, review_role_name, review_role_namespace, role_from, role_until, high_privilege, role_reason
) as r r.role_cluster = cluster_id and r.review_role_kind = role_kind and r.review_role_name = role_name and (role_kind = "ClusterRole" or r.review_role_namespace = namespace) and event_time >= r.role_from and event_time < r.role_until
| fields event_time, cluster_id, audit_id, user_name, resource, namespace, object_name, binding_uid, verb, role_kind, role_name, r.role_reason, response_code
| sort desc event_time
| limit 1000
