//Title
Investigation - Port 3389 Network Activity - RDP Candidates

//Description
Returns endpoint-associated TCP or UDP network records with local or remote port 3389 over one day, including direction, protocol and initiating-process context. The port identifies RDP candidates only; records do not establish an authenticated session, application identity or unauthorized access.

//Category
Investigation / Network Activity

:Query:

// Scope: Cortex XSIAM interactive XQL Search; one-day observation window.
// Full-query compilation and execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
// Documented event category 2 is Network; retain operation subtype context.
| filter event_type = 2
| filter agent_id != null and agent_id != ""
| filter action_network_protocol in (6, 17)
| filter (action_local_port = 3389 or action_remote_port = 3389)
// is_server true means incoming; false means outgoing; null remains unknown.
// network_success is a network-operation flag, not authentication or firewall action.

// Relevant investigation fields; actor fields describe the initiating process.
| fields
    _time,
    agent_id,
    agent_hostname,
    event_sub_type,
    action_local_ip,
    action_local_port,
    action_remote_ip,
    action_remote_port,
    action_network_is_server,
    action_network_protocol,
    action_network_success,
    action_network_connection_id,
    actor_process_image_name,
    actor_process_command_line,
    actor_process_instance_id,
    actor_effective_username
// Newest observed timestamps first; limit caps output, not upstream scanning.
| sort desc _time
| limit 1000
