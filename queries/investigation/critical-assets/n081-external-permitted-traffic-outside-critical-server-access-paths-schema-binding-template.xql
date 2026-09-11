//Title
External Permitted Traffic Outside Critical Server Access Paths - Schema Binding Template

//Description
Finds policy-permitted traffic from authoritatively external zones to time-valid critical servers when the exact source/server/protocol/port path is absent from a complete approved-path inventory.

//Category
Investigation / Critical Assets

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{INBOUND_FIREWALL_TRAFFIC}}
| alter event_time = {{INBOUND_TIME}},
    event_uid = {{INBOUND_UID}},
    firewall = {{INBOUND_FIREWALL}},
    source_zone = {{INBOUND_SOURCE_ZONE}},
    destination_zone = {{INBOUND_DEST_ZONE}},
    source_ip = {{INBOUND_SOURCE_IP}},
    destination_ip = {{INBOUND_DEST_IP}},
    translated_destination = {{INBOUND_TRANSLATED_DEST}},
    destination_port = {{INBOUND_DEST_PORT}},
    protocol = {{INBOUND_PROTOCOL}},
    action_class = {{INBOUND_ACTION_CLASS}},
    rule_id = {{INBOUND_RULE_ID}}
| filter action_class = "allow"
| alter zone_key = concat(firewall, "|", source_zone), server_ip = if(translated_destination != null and translated_destination != "", translated_destination, destination_ip)
| filter zone_key in ({{EXTERNAL_ZONE_KEYS}})
| filter server_ip != null and server_ip != ""
| join type = inner conflict_strategy = left (
dataset = {{CRITICAL_SERVER_IP_INVENTORY}}
| alter critical_ip = {{CRITICAL_SERVER_IP}},
    critical_endpoint = {{CRITICAL_SERVER_ENDPOINT}},
    critical_name = {{CRITICAL_SERVER_NAME}},
    critical_flag = {{CRITICAL_SERVER_FLAG}},
    critical_from = {{CRITICAL_SERVER_FROM}},
    critical_to = {{CRITICAL_SERVER_TO}}
| filter critical_flag = true
) as asset server_ip = asset.critical_ip and event_time >= asset.critical_from and event_time < asset.critical_to
| filter {{APPROVED_PATH_BASELINE_COMPLETE}} = true
| join type = left conflict_strategy = left (
dataset = {{APPROVED_CRITICAL_ACCESS_PATHS}}
| alter path_id = {{APPROVED_PATH_ID}},
    path_zone = {{APPROVED_PATH_ZONE_KEY}},
    path_source = {{APPROVED_PATH_SOURCE_IP}},
    path_endpoint = {{APPROVED_PATH_ENDPOINT}},
    path_protocol = {{APPROVED_PATH_PROTOCOL}},
    path_port = {{APPROVED_PATH_PORT}},
    path_from = {{APPROVED_PATH_FROM}},
    path_to = {{APPROVED_PATH_TO}}
) as approved zone_key = approved.path_zone and source_ip = approved.path_source and asset.critical_endpoint = approved.path_endpoint and protocol = approved.path_protocol and destination_port = approved.path_port and event_time >= approved.path_from and event_time < approved.path_to
| filter approved.path_id = null
| fields event_time, event_uid, firewall, source_zone, destination_zone, source_ip, destination_ip, translated_destination, server_ip, destination_port, protocol, rule_id, asset.critical_endpoint, asset.critical_name
| sort desc event_time
| limit 1000
