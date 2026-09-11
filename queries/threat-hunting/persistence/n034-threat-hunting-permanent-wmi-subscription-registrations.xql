//Title
Threat Hunting - Permanent WMI Subscription Registrations

//Description
Reviews permanent WMI filter, consumer and binding registrations/changes and resolves configured query/consumer targets through a validated object-state source.

//Category
Threat Hunting / Persistence

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{WMI_SUBSCRIPTIONS_DATASET}}
| alter event_time = {{WMI_SUBSCRIPTIONS_EVENT_TIME}},
    host_id = {{WMI_SUBSCRIPTIONS_HOST_ID}},
    event_id = {{WMI_SUBSCRIPTIONS_EVENT_ID}},
    namespace = {{WMI_SUBSCRIPTIONS_NAMESPACE}},
    subject = {{WMI_SUBSCRIPTIONS_SUBJECT}},
    object_name = {{WMI_SUBSCRIPTIONS_OBJECT_NAME}},
    filter_reference = {{WMI_SUBSCRIPTIONS_FILTER_REFERENCE}},
    consumer_reference = {{WMI_SUBSCRIPTIONS_CONSUMER_REFERENCE}},
    filter_query = {{WMI_SUBSCRIPTIONS_FILTER_QUERY}},
    consumer_target = {{WMI_SUBSCRIPTIONS_CONSUMER_TARGET}},
    operation = {{WMI_SUBSCRIPTIONS_OPERATION}}
| fields event_time, host_id, event_id, namespace, subject, object_name, filter_reference, consumer_reference, filter_query, consumer_target, operation
| filter event_id in (19, 20, 21)
| filter operation in ("CREATE", "REGISTER", "MODIFY")
| join type = left (
dataset = {{WMI_OBJECT_STATE_DATASET}}
| alter obj_host = {{WMI_OBJECT_STATE_OBJ_HOST}},
    obj_namespace = {{WMI_OBJECT_STATE_OBJ_NAMESPACE}},
    obj_reference = {{WMI_OBJECT_STATE_OBJ_REFERENCE}},
    obj_query = {{WMI_OBJECT_STATE_OBJ_QUERY}},
    obj_target = {{WMI_OBJECT_STATE_OBJ_TARGET}},
    obj_from = {{WMI_OBJECT_STATE_OBJ_FROM}},
    obj_until = {{WMI_OBJECT_STATE_OBJ_UNTIL}}
| fields obj_host, obj_namespace, obj_reference, obj_query, obj_target, obj_from, obj_until
) as f host_id = f.obj_host and namespace = f.obj_namespace and filter_reference = f.obj_reference
| join type = left (
dataset = {{WMI_OBJECT_STATE_DATASET}}
| alter obj_host = {{WMI_OBJECT_STATE_OBJ_HOST}},
    obj_namespace = {{WMI_OBJECT_STATE_OBJ_NAMESPACE}},
    obj_reference = {{WMI_OBJECT_STATE_OBJ_REFERENCE}},
    obj_query = {{WMI_OBJECT_STATE_OBJ_QUERY}},
    obj_target = {{WMI_OBJECT_STATE_OBJ_TARGET}},
    obj_from = {{WMI_OBJECT_STATE_OBJ_FROM}},
    obj_until = {{WMI_OBJECT_STATE_OBJ_UNTIL}}
| fields obj_host, obj_namespace, obj_reference, obj_query, obj_target, obj_from, obj_until
) as c host_id = c.obj_host and namespace = c.obj_namespace and consumer_reference = c.obj_reference
| alter filter_state_applies = if(event_time >= f.obj_from and (f.obj_until = null or event_time < f.obj_until), true, false),
    consumer_state_applies = if(event_time >= c.obj_from and (c.obj_until = null or event_time < c.obj_until), true, false)
| alter object_kind = if(event_id = 19, "FILTER", if(event_id = 20, "CONSUMER", "BINDING")),
    resolved_query = if(filter_query != null, filter_query, if(filter_state_applies = true, f.obj_query, null)),
    resolved_target = if(consumer_target != null, consumer_target, if(consumer_state_applies = true, c.obj_target, null))
| comp values(resolved_query) as resolved_queries, values(resolved_target) as resolved_targets by event_time, host_id, namespace, subject, object_kind, operation, object_name, filter_reference, consumer_reference
| fields event_time, host_id, namespace, subject, object_kind, operation, object_name, filter_reference, consumer_reference, resolved_queries, resolved_targets
| sort desc event_time
| limit 1000
