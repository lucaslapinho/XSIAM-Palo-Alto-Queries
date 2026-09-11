//Title
Dashboard - Outbound Destination Ports - Network Event Volume by Endpoint

//Description
Ranks outgoing endpoint-associated TCP and UDP network event rows by stable endpoint ID, IP protocol, remote port and operation subtype over one day. Keeps hostnames as context and excludes unknown direction or invalid ports; counts are event volume, not unique connections or identified applications.

//Category
Dashboard / Network Activity

:Query:

// Scope: Cortex XSIAM interactive XQL Search; one-day observation window.
// Full-query compilation and execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
// Documented event category 2 is Network; retain operation subtype context.
| filter event_type = 2
| filter agent_id != null and agent_id != ""
// IPPROTO 6 = TCP; IPPROTO 17 = UDP. False identifies outgoing observations.
| filter action_network_protocol in (6, 17)
| filter action_network_is_server = false
| filter action_remote_port != null and action_remote_port >= 1 and action_remote_port <= 65535
// Group by subtype to avoid hiding distinct network-operation populations.
| comp count() as network_event_rows, values(agent_hostname) as hostnames
    by agent_id, action_network_protocol, action_remote_port, event_sub_type
| fields agent_id, hostnames, action_network_protocol, action_remote_port, event_sub_type, network_event_rows
// Repeated records are intentionally counted; a port is not an App-ID.
| sort desc network_event_rows, asc agent_id, asc action_network_protocol, asc action_remote_port
| limit 100
