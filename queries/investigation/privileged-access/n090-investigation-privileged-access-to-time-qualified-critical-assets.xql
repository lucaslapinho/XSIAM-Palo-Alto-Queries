//Title
Investigation - Privileged Access to Time-Qualified Critical Assets

//Description
Correlates successful asset-access records with effective privileged entitlements and critical-asset classification valid at the event time. Requires explicit identity and asset contracts and returns entitlement context without assuming that every privileged access is inappropriate.

//Category
Investigation / Privileged Access

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{ASSET_ACCESS_EVENTS}}
| alter
    event_time = {{ACCESS_TIME}},
    event_id = {{ACCESS_EVENT_KEY}},
    principal_id = {{ACCESS_PRINCIPAL_ID}},
    asset_id = {{ACCESS_ASSET_ID}},
    access_action = {{ACCESS_ACTION}},
    access_success = {{ACCESS_SUCCESS}}
| filter access_success = true and principal_id != null and asset_id != null
| join type = inner conflict_strategy = both (
dataset = {{PRIVILEGED_ENTITLEMENT_HISTORY}}
| alter
    priv_principal = {{PRIVILEGED_PRINCIPAL_ID}},
    priv_asset = {{PRIVILEGED_ASSET_ID}},
    priv_from = {{PRIVILEGE_VALID_FROM}},
    priv_until = {{PRIVILEGE_VALID_UNTIL}},
    priv_role = {{PRIVILEGE_ROLE}}
| fields priv_principal, priv_asset, priv_from, priv_until, priv_role
) as pr pr.priv_principal = principal_id and pr.priv_asset = asset_id and event_time >= pr.priv_from and event_time < pr.priv_until
| join type = inner conflict_strategy = both (
dataset = {{CRITICAL_ASSET_HISTORY}}
| alter
    critical_asset = {{CRITICAL_ASSET_ID}},
    critical_from = {{CRITICAL_VALID_FROM}},
    critical_until = {{CRITICAL_VALID_UNTIL}},
    critical_owner = {{CRITICAL_OWNER}}
| fields critical_asset, critical_from, critical_until, critical_owner
) as ca ca.critical_asset = asset_id and event_time >= ca.critical_from and event_time < ca.critical_until
| fields event_time, event_id, principal_id, asset_id, access_action, pr.priv_role, ca.critical_owner
| sort desc event_time
| limit 1000
