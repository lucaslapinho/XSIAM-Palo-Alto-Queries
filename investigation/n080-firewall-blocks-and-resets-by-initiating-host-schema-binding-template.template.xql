// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{FIREWALL_TRAFFIC_DATASET}}
| alter event_time = {{FW_TIME}},
    event_uid = {{FW_EVENT_UID}},
    firewall = {{FW_DEVICE}},
    source_ip = {{FW_CLIENT_IP}},
    destination_ip = {{FW_SERVER_IP}},
    destination_port = {{FW_SERVER_PORT}},
    protocol = {{FW_PROTOCOL}},
    action_raw = {{FW_ACTION_RAW}},
    action_class = {{FW_ACTION_CLASS}},
    rule_id = {{FW_RULE_ID}},
    application = {{FW_APPLICATION}}
| filter action_class in ("deny", "drop", "reset_client", "reset_server", "reset_both")
| filter event_uid != null and event_uid != "" and source_ip != null and source_ip != ""
| dedup firewall, event_uid by asc event_time
| join type = left conflict_strategy = left (
dataset = {{SOURCE_IP_OWNERSHIP}}
| alter owned_ip = {{OWNER_IP}},
    owned_endpoint = {{OWNER_ENDPOINT}},
    owned_hostname = {{OWNER_HOSTNAME}},
    owner_from = {{OWNER_FROM}},
    owner_to = {{OWNER_TO}}
) as owner source_ip = owner.owned_ip and event_time >= owner.owner_from and event_time < owner.owner_to
| alter host_key = if(owner.owned_endpoint != null and owner.owned_endpoint != "", owner.owned_endpoint, concat("UNRESOLVED_IP:", source_ip)), enforcement_class = if(action_class in ("deny", "drop"), "BLOCK", "RESET")
| comp count() as firewall_log_records, count_distinct(destination_ip) as destination_count, values(destination_ip) as destinations, values(destination_port) as destination_ports, values(owner.owned_hostname) as hostnames, values(action_raw) as raw_actions by host_key, source_ip, firewall, rule_id, application, protocol, action_class, enforcement_class
| fields host_key, hostnames, source_ip, firewall, rule_id, application, protocol, action_class, enforcement_class, firewall_log_records, destination_count, destinations, destination_ports, raw_actions
| sort desc firewall_log_records
| limit 1000
