# Query catalog

**80 use cases: 11 candidates and 69 schema binding templates.** Full-query Cortex compilation/execution: **NOT RUN**. [Getting started](GETTING-STARTED.md) · [CSV](catalog/query-catalog.csv) · [JSON](catalog/query-catalog.json)

## Asset Visibility

| Proposal | Query | Kind | Guide |
|---|---|---|---|
| OP-016 | [N086 — Asset Visibility - All Reported Software Versions and Asset Groups](queries/asset-visibility/software-inventory/n086-asset-visibility-all-reported-software-versions-and-asset-groups.xql) | Binding template | [Read guide](guides/n086.md) |
| OP-017 | [N087 — Asset Visibility - Latest Local Administrators Membership Snapshot](queries/asset-visibility/local-privileges/n087-asset-visibility-latest-local-administrators-membership-snapshot.xql) | Binding template | [Read guide](guides/n087.md) |
| OP-021 | [N091 — Asset Visibility - Latest Agent Version and Reported Health](queries/asset-visibility/agent-health/n091-asset-visibility-latest-agent-version-and-reported-health.xql) | Binding template | [Read guide](guides/n091.md) |

## Cyber Hygiene

| Proposal | Query | Kind | Guide |
|---|---|---|---|
| TH-039 | [N063 — Cyber Hygiene - Remote Desktop Observations without a Matching Scoped Approval](queries/cyber-hygiene/software-approval/n063-cyber-hygiene-remote-desktop-observations-without-a-matching-scoped-approval.xql) | Binding template | [Read guide](guides/n063.md) |
| OP-022 | [N092 — Cyber Hygiene - Expected Endpoints with Missing Recent Process or Network Telemetry](queries/cyber-hygiene/collection-coverage/n092-cyber-hygiene-expected-endpoints-with-missing-recent-process-or-network-telemetry.xql) | Binding template | [Read guide](guides/n092.md) |

## Dashboard

| Proposal | Query | Kind | Guide |
|---|---|---|---|
| OP-008 | [N025 — Dashboard - Outbound Destination Ports - Network Event Volume by Endpoint](queries/dashboard/network-activity/n025-dashboard-outbound-destination-ports-network-event-volume-by-endpoint.xql) | Candidate | [Read guide](guides/n025.md) |

## Investigation

| Proposal | Query | Kind | Guide |
|---|---|---|---|
| OP-001 | [N023 — Investigation - Port 3389 Network Activity - RDP Candidates](queries/investigation/network-activity/n023-investigation-port-3389-network-activity-rdp-candidates.xql) | Candidate | [Read guide](guides/n023.md) |
| OP-005 | [N024 — Investigation - Selected Endpoint Network Event Timeline](queries/investigation/network-activity/n024-investigation-selected-endpoint-network-event-timeline.xql) | Candidate | [Read guide](guides/n024.md) |
| OP-011 | [N026 — Investigation - Selected Endpoint Process Start Timeline](queries/investigation/process-activity/n026-investigation-selected-endpoint-process-start-timeline.xql) | Candidate | [Read guide](guides/n026.md) |
| OP-002 | [N075 — Successful RemoteInteractive Logon Records - Schema Binding Template](queries/investigation/rdp-authentication/n075-successful-remoteinteractive-logon-records-schema-binding-template.xql) | Binding template | [Read guide](guides/n075.md) |
| OP-003 | [N076 — Failed RDP Authentication Evidence Review - Schema Binding Template](queries/investigation/rdp-authentication/n076-failed-rdp-authentication-evidence-review-schema-binding-template.xql) | Binding template | [Read guide](guides/n076.md) |
| OP-004 | [N077 — Classified RDP Traffic on Standard and Nonstandard Ports - Schema Binding Template](queries/investigation/rdp-network-activity/n077-classified-rdp-traffic-on-standard-and-nonstandard-ports-schema-binding-template.xql) | Binding template | [Read guide](guides/n077.md) |
| OP-006 | [N078 — Exact IP Investigation Across Address Roles - Schema Binding Template](queries/investigation/network-activity/n078-exact-ip-investigation-across-address-roles-schema-binding-template.xql) | Binding template | [Read guide](guides/n078.md) |
| OP-007 | [N079 — Domain DNS and Web Observation Lookup - Schema Binding Template](queries/investigation/dns-and-web/n079-domain-dns-and-web-observation-lookup-schema-binding-template.xql) | Binding template | [Read guide](guides/n079.md) |
| OP-009 | [N080 — Firewall Blocks and Resets by Initiating Host - Schema Binding Template](queries/investigation/firewall/n080-firewall-blocks-and-resets-by-initiating-host-schema-binding-template.xql) | Binding template | [Read guide](guides/n080.md) |
| OP-010 | [N081 — External Permitted Traffic Outside Critical Server Access Paths - Schema Binding Template](queries/investigation/critical-assets/n081-external-permitted-traffic-outside-critical-server-access-paths-schema-binding-template.xql) | Binding template | [Read guide](guides/n081.md) |
| OP-012 | [N082 — Investigation - Selected Process with Direct Parent and Children](queries/investigation/process-relationships/n082-investigation-selected-process-with-direct-parent-and-children.xql) | Binding template | [Read guide](guides/n082.md) |
| OP-013 | [N083 — Investigation - Selected SHA-256 Process and File Prevalence](queries/investigation/file-identity/n083-investigation-selected-sha-256-process-and-file-prevalence.xql) | Candidate | [Read guide](guides/n083.md) |
| OP-014 | [N084 — Investigation - File Creation Write Rename and Deletion Timeline](queries/investigation/file-activity/n084-investigation-file-creation-write-rename-and-deletion-timeline.xql) | Binding template | [Read guide](guides/n084.md) |
| OP-015 | [N085 — Investigation - Executable Hashes Newly Observed Against a Prior Baseline](queries/investigation/executable-baselines/n085-investigation-executable-hashes-newly-observed-against-a-prior-baseline.xql) | Candidate | [Read guide](guides/n085.md) |
| OP-018 | [N088 — Investigation - Selected Identity Authentication Timeline](queries/investigation/authentication/n088-investigation-selected-identity-authentication-timeline.xql) | Binding template | [Read guide](guides/n088.md) |
| OP-019 | [N089 — Investigation - Account Lockouts with Preceding Authentication Failures](queries/investigation/account-lockouts/n089-investigation-account-lockouts-with-preceding-authentication-failures.xql) | Binding template | [Read guide](guides/n089.md) |
| OP-020 | [N090 — Investigation - Privileged Access to Time-Qualified Critical Assets](queries/investigation/privileged-access/n090-investigation-privileged-access-to-time-qualified-critical-assets.xql) | Binding template | [Read guide](guides/n090.md) |
| OP-029 | [N099 — Investigation - Selected AWS Account API Audit Timeline](queries/investigation/aws-audit/n099-investigation-selected-aws-account-api-audit-timeline.xql) | Binding template | [Read guide](guides/n099.md) |
| OP-030 | [N100 — Investigation - Kubernetes Audit Timeline with Time-Valid Workload Context](queries/investigation/kubernetes-audit/n100-investigation-kubernetes-audit-timeline-with-time-valid-workload-context.xql) | Binding template | [Read guide](guides/n100.md) |

## Security Operations

| Proposal | Query | Kind | Guide |
|---|---|---|---|
| OP-023 | [N093 — Security Operations - Domain Controller Operational Event Timeline](queries/security-operations/domain-controllers/n093-security-operations-domain-controller-operational-event-timeline.xql) | Binding template | [Read guide](guides/n093.md) |
| OP-024 | [N094 — Security Operations - Cortex Management Audit Timeline](queries/security-operations/cortex-audit/n094-security-operations-cortex-management-audit-timeline.xql) | Candidate | [Read guide](guides/n094.md) |
| OP-025 | [N095 — Security Operations - Cortex Role and API Credential Lifecycle Audit](queries/security-operations/cortex-audit/n095-security-operations-cortex-role-and-api-credential-lifecycle-audit.xql) | Binding template | [Read guide](guides/n095.md) |
| OP-026 | [N096 — Security Operations - Cortex Response Requests and Terminal Outcomes](queries/security-operations/response-audit/n096-security-operations-cortex-response-requests-and-terminal-outcomes.xql) | Binding template | [Read guide](guides/n096.md) |
| OP-027 | [N097 — Security Operations - Collector Error and Warning Audit Records](queries/security-operations/collection-health/n097-security-operations-collector-error-and-warning-audit-records.xql) | Candidate | [Read guide](guides/n097.md) |
| OP-028 | [N098 — Security Operations - Data Source Freshness and Interval Volume](queries/security-operations/ingestion-health/n098-security-operations-data-source-freshness-and-interval-volume.xql) | Candidate | [Read guide](guides/n098.md) |

## Threat Hunting

| Proposal | Query | Kind | Guide |
|---|---|---|---|
| TH-001 | [N021 — Threat Hunting - PowerShell Encoded Command Launch Candidates](queries/threat-hunting/powershell/n021-threat-hunting-powershell-encoded-command-launch-candidates.xql) | Candidate | [Read guide](guides/n021.md) |
| TH-021 | [N022 — Threat Hunting - Domain Account Discovery - Net User Query Attempts](queries/threat-hunting/account-discovery/n022-threat-hunting-domain-account-discovery-net-user-query-attempts.xql) | Candidate | [Read guide](guides/n022.md) |
| TH-002 | [N027 — Threat Hunting - Office Command Shells and Subsequent Activity](queries/threat-hunting/execution/n027-threat-hunting-office-command-shells-and-subsequent-activity.xql) | Binding template | [Read guide](guides/n027.md) |
| TH-003 | [N028 — Threat Hunting - WMI Child Processes with Request Origin](queries/threat-hunting/execution/n028-threat-hunting-wmi-child-processes-with-request-origin.xql) | Binding template | [Read guide](guides/n028.md) |
| TH-004 | [N029 — Threat Hunting - Mshta URL or Script References and Follow-on Activity](queries/threat-hunting/proxy-execution/n029-threat-hunting-mshta-url-or-script-references-and-follow-on-activity.xql) | Binding template | [Read guide](guides/n029.md) |
| TH-005 | [N030 — Threat Hunting - Rundll32 Module Paths and Unusual Argument Candidates](queries/threat-hunting/proxy-execution/n030-threat-hunting-rundll32-module-paths-and-unusual-argument-candidates.xql) | Binding template | [Read guide](guides/n030.md) |
| TH-006 | [N031 — Threat Hunting - Scheduled Task Configuration Change Review](queries/threat-hunting/persistence/n031-threat-hunting-scheduled-task-configuration-change-review.xql) | Binding template | [Read guide](guides/n031.md) |
| TH-007 | [N032 — Threat Hunting - New Services in Profile or Temporary Paths](queries/threat-hunting/persistence/n032-threat-hunting-new-services-in-profile-or-temporary-paths.xql) | Binding template | [Read guide](guides/n032.md) |
| TH-008 | [N033 — Threat Hunting - Run Key and Startup Artifact Mutations](queries/threat-hunting/persistence/n033-threat-hunting-run-key-and-startup-artifact-mutations.xql) | Binding template | [Read guide](guides/n033.md) |
| TH-009 | [N034 — Threat Hunting - Permanent WMI Subscription Registrations](queries/threat-hunting/persistence/n034-threat-hunting-permanent-wmi-subscription-registrations.xql) | Binding template | [Read guide](guides/n034.md) |
| TH-010 | [N035 — Threat Hunting - Privileged Group Membership Additions](queries/threat-hunting/identity/n035-threat-hunting-privileged-group-membership-additions.xql) | Binding template | [Read guide](guides/n035.md) |
| TH-011 | [N036 — Threat Hunting - New Domain Accounts and Early Lifecycle Activity](queries/threat-hunting/identity/n036-threat-hunting-new-domain-accounts-and-early-lifecycle-activity.xql) | Binding template | [Read guide](guides/n036.md) |
| TH-012 | [N037 — Threat Hunting - Configured SSH Authorized Keys File Changes](queries/threat-hunting/persistence/n037-threat-hunting-configured-ssh-authorized-keys-file-changes.xql) | Binding template | [Read guide](guides/n037.md) |
| TH-013 | [N038 — Threat Hunting - LSASS Memory-capable Access and Dump-file Candidates](queries/threat-hunting/credential-access/n038-threat-hunting-lsass-memory-capable-access-and-dump-file-candidates.xql) | Binding template | [Read guide](guides/n038.md) |
| TH-014 | [N039 — Threat Hunting - SAM Hive Save Attempts and Related Artifacts](queries/threat-hunting/credential-access/n039-threat-hunting-sam-hive-save-attempts-and-related-artifacts.xql) | Binding template | [Read guide](guides/n039.md) |
| TH-015 | [N040 — Threat Hunting - Domain Controller Database and Snapshot Activity](queries/threat-hunting/credential-access/n040-threat-hunting-domain-controller-database-and-snapshot-activity.xql) | Binding template | [Read guide](guides/n040.md) |
| TH-016 | [N041 — Threat Hunting - Unexpected Replication Rights Use with Source Context](queries/threat-hunting/credential-access/n041-threat-hunting-unexpected-replication-rights-use-with-source-context.xql) | Binding template | [Read guide](guides/n041.md) |
| TH-017 | [N042 — Threat Hunting - Service-ticket Bursts and Rare Requesters](queries/threat-hunting/credential-access/n042-threat-hunting-service-ticket-bursts-and-rare-requesters.xql) | Binding template | [Read guide](guides/n042.md) |
| TH-018 | [N043 — Threat Hunting - No-preauthentication Accounts and TGT Request Activity](queries/threat-hunting/credential-access/n043-threat-hunting-no-preauthentication-accounts-and-tgt-request-activity.xql) | Binding template | [Read guide](guides/n043.md) |
| TH-019 | [N044 — Password Spraying Across Accounts - Schema Binding Template](queries/threat-hunting/credential-access/n044-password-spraying-across-accounts-schema-binding-template.xql) | Binding template | [Read guide](guides/n044.md) |
| TH-020 | [N045 — Browser Credential Store Read Access - Schema Binding Template](queries/threat-hunting/credential-access/n045-browser-credential-store-read-access-schema-binding-template.xql) | Binding template | [Read guide](guides/n045.md) |
| TH-022 | [N046 — Privileged Domain Group Discovery - Schema Binding Template](queries/threat-hunting/discovery/n046-privileged-domain-group-discovery-schema-binding-template.xql) | Binding template | [Read guide](guides/n046.md) |
| TH-023 | [N047 — Internal Service Scanning Fan-Out Candidates - Schema Binding Template](queries/threat-hunting/discovery/n047-internal-service-scanning-fan-out-candidates-schema-binding-template.xql) | Binding template | [Read guide](guides/n047.md) |
| TH-024 | [N048 — Network Share Enumeration Requests - Schema Binding Template](queries/threat-hunting/discovery/n048-network-share-enumeration-requests-schema-binding-template.xql) | Binding template | [Read guide](guides/n048.md) |
| TH-025 | [N049 — Security Tool Discovery Requests - Schema Binding Template](queries/threat-hunting/discovery/n049-security-tool-discovery-requests-schema-binding-template.xql) | Binding template | [Read guide](guides/n049.md) |
| TH-026 | [N050 — RDP from Sources Absent in a Verified Baseline - Schema Binding Template](queries/threat-hunting/lateral-movement/n050-rdp-from-sources-absent-in-a-verified-baseline-schema-binding-template.xql) | Binding template | [Read guide](guides/n050.md) |
| TH-027 | [N051 — Successful RDP Fan-Out Across Servers - Schema Binding Template](queries/threat-hunting/lateral-movement/n051-successful-rdp-fan-out-across-servers-schema-binding-template.xql) | Binding template | [Read guide](guides/n051.md) |
| TH-028 | [N052 — RDP Session Followed by PowerShell Behavior - Schema Binding Template](queries/threat-hunting/lateral-movement/n052-rdp-session-followed-by-powershell-behavior-schema-binding-template.xql) | Binding template | [Read guide](guides/n052.md) |
| TH-029 | [N053 — SMB File Write Followed by Service Execution - Schema Binding Template](queries/threat-hunting/lateral-movement/n053-smb-file-write-followed-by-service-execution-schema-binding-template.xql) | Binding template | [Read guide](guides/n053.md) |
| TH-030 | [N054 — WinRM Session and Descendant Process Review - Schema Binding Template](queries/threat-hunting/lateral-movement/n054-winrm-session-and-descendant-process-review-schema-binding-template.xql) | Binding template | [Read guide](guides/n054.md) |
| TH-031 | [N055 — SSH Accepted Access and Session Command Review - Schema Binding Template](queries/threat-hunting/lateral-movement/n055-ssh-accepted-access-and-session-command-review-schema-binding-template.xql) | Binding template | [Read guide](guides/n055.md) |
| TH-032 | [N056 — Security Tool Disablement Requests - Schema Binding Template](queries/threat-hunting/defense-impairment/n056-security-tool-disablement-requests-schema-binding-template.xql) | Binding template | [Read guide](guides/n056.md) |
| TH-033 | [N057 — Windows Event Log Clearing Records - Schema Binding Template](queries/threat-hunting/defense-impairment/n057-windows-event-log-clearing-records-schema-binding-template.xql) | Binding template | [Read guide](guides/n057.md) |
| TH-034 | [N058 — CloudTrail StopLogging Requests and Observed Trail State - Schema Binding Template](queries/threat-hunting/defense-impairment/n058-cloudtrail-stoplogging-requests-and-observed-trail-state-schema-binding-template.xql) | Binding template | [Read guide](guides/n058.md) |
| TH-035 | [N059 — Prevention Policy Enforcement Loss Across Snapshots - Schema Binding Template](queries/threat-hunting/defense-impairment/n059-prevention-policy-enforcement-loss-across-snapshots-schema-binding-template.xql) | Binding template | [Read guide](guides/n059.md) |
| TH-036 | [N060 — Threat Hunting - High-Cardinality DNS Name Candidates](queries/threat-hunting/dns/n060-threat-hunting-high-cardinality-dns-name-candidates.xql) | Binding template | [Read guide](guides/n060.md) |
| TH-037 | [N061 — Threat Hunting - Periodic Identified Web Connection Candidates](queries/threat-hunting/network-periodicity/n061-threat-hunting-periodic-identified-web-connection-candidates.xql) | Binding template | [Read guide](guides/n061.md) |
| TH-038 | [N062 — Threat Hunting - Inbound Transfers with Attributed Output Files](queries/threat-hunting/tool-transfer/n062-threat-hunting-inbound-transfers-with-attributed-output-files.xql) | Binding template | [Read guide](guides/n062.md) |
| TH-040 | [N064 — Threat Hunting - Large Archive Creation with Observed Input Context](queries/threat-hunting/data-staging/n064-threat-hunting-large-archive-creation-with-observed-input-context.xql) | Binding template | [Read guide](guides/n064.md) |
| TH-041 | [N065 — Threat Hunting - Successful Uploads to Externally Owned Cloud Storage](queries/threat-hunting/cloud-transfers/n065-threat-hunting-successful-uploads-to-externally-owned-cloud-storage.xql) | Binding template | [Read guide](guides/n065.md) |
| TH-042 | [N066 — Threat Hunting - Recovery Tampering Requests and Observed State Changes](queries/threat-hunting/recovery-controls/n066-threat-hunting-recovery-tampering-requests-and-observed-state-changes.xql) | Binding template | [Read guide](guides/n066.md) |
| TH-043 | [N067 — Threat Hunting - Mass File Mutation Candidates by Process](queries/threat-hunting/file-activity/n067-threat-hunting-mass-file-mutation-candidates-by-process.xql) | Binding template | [Read guide](guides/n067.md) |
| TH-044 | [N068 — Threat Hunting - Observed Stops of Critical Services](queries/threat-hunting/service-availability/n068-threat-hunting-observed-stops-of-critical-services.xql) | Binding template | [Read guide](guides/n068.md) |
| TH-045 | [N069 — Threat Hunting - Sustained CPU Use with Attributed Mining Communication](queries/threat-hunting/resource-abuse/n069-threat-hunting-sustained-cpu-use-with-attributed-mining-communication.xql) | Binding template | [Read guide](guides/n069.md) |
| TH-046 | [N070 — Threat Hunting - AWS Attachments of Reviewed High-Privilege Policies](queries/threat-hunting/cloud-privileges/n070-threat-hunting-aws-attachments-of-reviewed-high-privilege-policies.xql) | Binding template | [Read guide](guides/n070.md) |
| TH-047 | [N071 — Threat Hunting - AWS Access Key Creation and First Observed Use](queries/threat-hunting/cloud-credentials/n071-threat-hunting-aws-access-key-creation-and-first-observed-use.xql) | Binding template | [Read guide](guides/n071.md) |
| TH-048 | [N072 — Threat Hunting - Kubernetes Pod Exec and Attach Audit Responses](queries/threat-hunting/kubernetes-access/n072-threat-hunting-kubernetes-pod-exec-and-attach-audit-responses.xql) | Binding template | [Read guide](guides/n072.md) |
| TH-049 | [N073 — Threat Hunting - Kubernetes Bindings to Reviewed Privileged Roles](queries/threat-hunting/kubernetes-rbac/n073-threat-hunting-kubernetes-bindings-to-reviewed-privileged-roles.xql) | Binding template | [Read guide](guides/n073.md) |
| TH-050 | [N074 — Threat Hunting - Admitted Containers with Privileged or Host-Access Settings](queries/threat-hunting/kubernetes-workloads/n074-threat-hunting-admitted-containers-with-privileged-or-host-access-settings.xql) | Binding template | [Read guide](guides/n074.md) |
