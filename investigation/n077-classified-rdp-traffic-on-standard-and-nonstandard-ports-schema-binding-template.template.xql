// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{RDP_NETWORK_CLASSIFICATION_DATASET}}
| alter event_time = {{RDP_FLOW_TIME}},
    flow_uid = {{RDP_FLOW_UID}},
    endpoint = {{RDP_CLIENT_ENDPOINT}},
    source_ip = {{RDP_FLOW_SOURCE_IP}},
    source_port = {{RDP_FLOW_SOURCE_PORT}},
    destination_ip = {{RDP_FLOW_DEST_IP}},
    destination_port = {{RDP_FLOW_DEST_PORT}},
    protocol = {{RDP_FLOW_PROTOCOL}},
    application = {{RDP_FLOW_APPLICATION}},
    action = {{RDP_FLOW_ACTION}},
    process_instance = {{RDP_FLOW_PROCESS_INSTANCE}}
| filter application in ({{RDP_APPLICATION_VALUES}})
| filter destination_port != null and destination_port >= 1 and destination_port <= 65535
| alter port_class = if(destination_port = 3389, "STANDARD_3389", "NONSTANDARD_PORT")
| join type = left conflict_strategy = left (
dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and action_process_instance_id != null
| fields agent_id as client_endpoint, action_process_instance_id as client_instance, action_process_image_name as client_image, action_process_image_command_line as client_command, action_process_signature_vendor as client_signer
) as client endpoint = client.client_endpoint and process_instance = client.client_instance
| fields event_time, flow_uid, endpoint, source_ip, source_port, destination_ip, destination_port, protocol, application, action, port_class, client.client_image, client.client_command, client.client_signer
| sort desc event_time
| limit 1000
