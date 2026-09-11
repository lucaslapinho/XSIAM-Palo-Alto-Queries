//Title
Internal Service Scanning Fan-Out Candidates - Schema Binding Template

//Description
Groups outgoing TCP/UDP endpoint-associated network observations into five-minute bins and selects high destination or port fan-out within verified internal address scope.

//Category
Threat Hunting / Discovery

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = xdr_data
| filter event_type = 2 and agent_id != null and agent_id != ""
| filter action_network_is_server = false
| filter action_network_protocol in (6, 17)
| filter action_remote_ip != null and action_remote_ip != "" and action_remote_port >= 1 and action_remote_port <= 65535
| filter ({{INTERNAL_DESTINATION_PREDICATE}})
| alter bucket = _time
| bin bucket span = 5m
| comp count() as network_event_rows, count_distinct(action_remote_ip) as target_count, count_distinct(action_remote_port) as port_count, values(action_remote_ip) as targets, values(action_remote_port) as ports, values(actor_process_image_name) as initiating_images by agent_id, action_network_protocol, event_sub_type, bucket
| filter (target_count >= {{MIN_TARGETS}} or port_count >= {{MIN_PORTS}})
| fields bucket, agent_id, action_network_protocol, event_sub_type, target_count, port_count, network_event_rows, targets, ports, initiating_images
| sort desc target_count
| limit 1000
