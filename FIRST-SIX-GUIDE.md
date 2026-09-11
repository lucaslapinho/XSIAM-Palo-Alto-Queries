# Query guide

Product: Cortex XSIAM. Surface: interactive XQL Search. Documentation review: 2026-09-11; tenant product version is not established by these artifacts. These candidates are not certified for BIOC, scheduled/real-time correlation, API import or other surfaces.

Common boundaries: `xdr_data` can contain endpoint and network-security data; an agent ID establishes endpoint association, not exclusive agent origin. `_time` describes the retained observation timestamp and can have insertion-time fallback. Null or missing data, permissions, retention and collection gaps can make results incomplete. Names, command lines and ports do not prove identity or maliciousness. No measured speedup or performance guarantee is claimed.

## N021 - Threat Hunting - PowerShell Encoded Command Launch Candidates

Source proposal: TH-001. Category: Threat Hunting / PowerShell.

Finds process-start records for Windows PowerShell or pwsh with selected encoded-command launch switches and a Base64-shaped argument. Returns image, user, initiating-process and signature context; matching does not validate the payload or prove successful or malicious execution.

**Output grain:** One retained process-start telemetry row; no decoded payload or execution-success assertion.

**Stage behavior:** Select the documented event category and process-start subtype where applicable; filter the stated host or behavior; project investigation fields; sort newest observations first and keep 1000 rows.

- Windows PowerShell: EncodedCommand/enc; Windows pwsh: EncodedCommand/e/ec/enc.
- The allowlisted prefix grammar admits full NoProfile, NonInteractive, NoLogo, NoExit, STA, MTA, ExecutionPolicy plus selected values, and WindowStyle plus selected values.
- The payload is only nonempty Base64-character-shaped text, not validated or decoded content.

**Benign matches:** Legitimate deployment, administration and automation can use encoded commands.

**Misses and limitations:** Intentionally misses unlisted abbreviations (including Windows -nop/-e), renamed executables, omitted argv0, unsupported quoting, arguments after the payload, missing telemetry and non-Windows hosts.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

**Next checks:** Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample. Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results. Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.

## N022 - Threat Hunting - Domain Account Discovery - Net User Query Attempts

Source proposal: TH-021. Category: Threat Hunting / Account Discovery.

Finds net.exe or net1.exe process starts requesting primary-domain user listings or a single user detail view with an explicit /domain switch. Restricts command shapes to exclude account-changing arguments; results show query attempts and require administrative context and outcome verification.

**Output grain:** One process-start telemetry row; net/net1 can generate related observations and no unique discovery count is claimed.

**Stage behavior:** Select the documented event category and process-start subtype where applicable; filter the stated host or behavior; project investigation fields; sort newest observations first and keep 1000 rows.

- An optional single ordinary ASCII username is allowed; a single lookup is not bulk enumeration.
- The command shape excludes extra passwords, /add, /delete and property switches.
- dsquery and Get-ADUser are outside this deliberately constrained implementation.

**Benign matches:** Help desk, identity administration, inventory scripts and authorized assessments can request the same information.

**Misses and limitations:** Misses other directory tools/APIs, reversed argument order, abbreviated domain switches, exotic usernames, unsupported quoting, renamed tools and missing command lines.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

**Next checks:** Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample. Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results. Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.

## N023 - Investigation - Port 3389 Network Activity - RDP Candidates

Source proposal: OP-001. Category: Investigation / Network Activity.

Returns endpoint-associated TCP or UDP network records with local or remote port 3389 over one day, including direction, protocol and initiating-process context. The port identifies RDP candidates only; records do not establish an authenticated session, application identity or unauthorized access.

**Output grain:** One network event row with a port-3389 tuple; no session reconstruction.

**Stage behavior:** Select the documented event category and process-start subtype where applicable; filter the stated host or behavior; project investigation fields; sort newest observations first and keep 1000 rows.

- Local and remote tuples retain their native endpoint perspective.
- Network success does not mean successful sign-in.
- An agent ID establishes endpoint association, not exclusive EDR provenance.

**Benign matches:** Approved RDP, unrelated software on port 3389 and repeated network-operation records can appear.

**Misses and limitations:** Misses RDP on alternative ports, tunnel/gateway traffic without this tuple, missing agent association and incomplete network telemetry.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

**Next checks:** Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample. Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results. Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.

## N024 - Investigation - Selected Endpoint Network Event Timeline

Source proposal: OP-005. Category: Investigation / Network Activity.

Returns the newest 1000 network records within one day for a required stable endpoint ID, preserving local and remote tuples, operation subtype, direction, success flag and initiating-process context. This is an observation timeline rather than a reconstruction of unique sessions or firewall decisions.

**Output grain:** One network event row ordered by its observed _time; timestamp ties have no guaranteed order.

**Stage behavior:** Select the documented event category and process-start subtype where applicable; filter the stated host or behavior; project investigation fields; sort newest observations first and keep 1000 rows.

- REQUIRED parameter: replace AGENT_ID_TO_REVIEW with the intended stable endpoint ID.
- Connection ID uniqueness and lifetime have not been established; no deduplication is applied.
- Network success is not a firewall allow/deny action or authenticated session result.

**Benign matches:** Expected background services and routine traffic remain in this broad investigative timeline.

**Misses and limitations:** Rows outside the selected endpoint/day, beyond the newest 1000 results, or absent from accessible telemetry are not shown.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

**Next checks:** Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample. Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results. Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.

## N025 - Dashboard - Outbound Destination Ports - Network Event Volume by Endpoint

Source proposal: OP-008. Category: Dashboard / Network Activity.

Ranks outgoing endpoint-associated TCP and UDP network event rows by stable endpoint ID, IP protocol, remote port and operation subtype over one day. Keeps hostnames as context and excludes unknown direction or invalid ports; counts are event volume, not unique connections or identified applications.

**Output grain:** One group per agent_id, IP protocol, remote port and operation subtype; metric is count of admitted rows.

**Stage behavior:** Select Network category, stable endpoint, outgoing TCP/UDP and valid remote port; aggregate by endpoint/protocol/port/subtype; rank by event-row count and keep 100 groups.

- This proposal is implemented as destination-port visibility; App-ID ranking requires separately verified application telemetry.
- For outgoing rows the remote port is the destination port; incoming rows are deliberately excluded.
- Hostname changes do not split stable endpoint groups; values preserves distinct observed labels.
- No connection-ID uniqueness or session-start subtype is assumed.

**Benign matches:** Frequent authorized traffic and collection/statistics cadence can dominate the ranking.

**Misses and limitations:** Excludes incoming/unknown direction, absent agent IDs, invalid/null ports, non-TCP/UDP protocols and groups outside the top 100.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

**Next checks:** Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample. Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results. Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.

## N026 - Investigation - Selected Endpoint Process Start Timeline

Source proposal: OP-011. Category: Investigation / Process Activity.

Returns the newest 1000 process-start records within one day for a required stable endpoint ID, with started-process command line, user, hash, signature and initiating-process context. Ordering describes observed timestamps and does not reconstruct ancestry, process lifetime or current running state.

**Output grain:** One process-start telemetry row ordered newest first; not a process tree or a current-process inventory.

**Stage behavior:** Select the documented event category and process-start subtype where applicable; filter the stated host or behavior; project investigation fields; sort newest observations first and keep 1000 rows.

- REQUIRED parameter: replace AGENT_ID_TO_REVIEW with the intended stable endpoint ID.
- Actor fields represent the initiating process; a direct-parent relationship is not asserted.
- Timestamp ties are not ordered and _time may include insertion-time fallback.

**Benign matches:** Routine service, user and administrative process starts remain visible by design.

**Misses and limitations:** Misses starts outside the selected day, older rows beyond the result cap, missing collection and inaccessible endpoint telemetry.

**Performance:** Explicit one-day scope and early filters reduce the admitted population; no performance measurements. A final limit caps returned rows, not scan cost.

**Next checks:** Validate exact body in the target XQL editor, then review a bounded known-positive and known-negative sample. Confirm endpoint identity, collection scope, timestamps and missing fields before interpreting results. Correlate concerning observations with approved changes, process identity and independent authentication/network evidence.

## Field interpretation

Process queries use `action_process_*` for the started process and `actor_process_*` / `actor_effective_username` for initiating context; the latter is not asserted to be a direct parent or interactive user. Instance IDs support pivots but no join or uniqueness assumption is made. Hash/signature fields support identity review, not trust by themselves.

Network queries retain local/remote IPs and ports relative to the observed endpoint. `action_network_is_server = true` means incoming; false means outgoing; null is unknown. `action_network_protocol` is the numeric IP protocol (6 TCP, 17 UDP). `action_network_success` is a network-operation flag, not successful authentication or firewall allow/deny. `action_network_connection_id` is context only; its lifetime and uniqueness are not established. Multiple subtypes/statistics may represent the same connection.

N025 counts records and preserves subtype as a grouping dimension. Its remote port is a destination port because the query admits only outgoing records. It cannot provide App-ID or unique-session ranking. The broad application proposal therefore remains only partially covered.

## ATT&CK context

N021 is related to T1059.001 (PowerShell); N022 to T1087.002 (Domain Account). These are contextual investigation mappings, not evidence of an adversary, successful execution, or measured detection coverage. N023-N026 are neutral visibility and carry N/A.
