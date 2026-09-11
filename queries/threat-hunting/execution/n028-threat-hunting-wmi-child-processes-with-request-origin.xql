//Title
Threat Hunting - WMI Child Processes with Request Origin

//Description
Reviews verified WmiPrvSE child starts with time-qualified WMI request source, account, namespace, result and management-baseline context. Missing traces remain unassessed.

//Category
Threat Hunting / Execution

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != "" and action_process_instance_id != null and action_process_instance_id != ""
| alter direct_parent_image = {{WMI_DIRECT_PARENT_IMAGE}}
| filter direct_parent_image = "wmiprvse.exe"
| alter anchor_time = _time, endpoint_id = agent_id, anchor_process_id = action_process_instance_id,
    anchor_command = action_process_image_command_line, anchor_actor = action_process_username
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor
| join type = left (
dataset = {{WMI_TRACE_DATASET}}
| alter w_host = {{WMI_TRACE_W_HOST}},
    w_child = {{WMI_TRACE_W_CHILD}},
    w_time = {{WMI_TRACE_W_TIME}},
    w_client = {{WMI_TRACE_W_CLIENT}},
    w_account = {{WMI_TRACE_W_ACCOUNT}},
    w_namespace = {{WMI_TRACE_W_NAMESPACE}},
    w_operation = {{WMI_TRACE_W_OPERATION}},
    w_result = {{WMI_TRACE_W_RESULT}},
    w_expected = {{WMI_TRACE_W_EXPECTED}}
| fields w_host, w_child, w_time, w_client, w_account, w_namespace, w_operation, w_result, w_expected
) as w endpoint_id = w.w_host and anchor_process_id = w.w_child
| alter trace_seconds = timestamp_diff(w.w_time, anchor_time, "SECOND")
| alter trace_in_window = if(trace_seconds >= -60 and trace_seconds <= 300, true, false)
| alter origin_state = if(trace_in_window = true, "CORRELATED_TRACE", "NO_TRACE_IN_WINDOW"),
    management_state = if(trace_in_window = false or w.w_expected = null, "UNASSESSED", if(w.w_expected = true, "EXPECTED_BASELINE", "REVIEW_BASELINE_DEVIATION")),
    source_host = if(trace_in_window = true, w.w_client, null), request_account = if(trace_in_window = true, w.w_account, null),
    wmi_namespace = if(trace_in_window = true, w.w_namespace, null), wmi_operation = if(trace_in_window = true, w.w_operation, null), wmi_result = if(trace_in_window = true, w.w_result, null)
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, origin_state, management_state, source_host, request_account, wmi_namespace, wmi_operation, wmi_result
| sort desc anchor_time
| limit 1000
