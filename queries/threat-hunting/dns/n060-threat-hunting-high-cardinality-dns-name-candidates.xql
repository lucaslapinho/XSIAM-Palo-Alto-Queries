//Title
Threat Hunting - High-Cardinality DNS Name Candidates

//Description
Ranks endpoint and base-domain groups with many distinct and long DNS query names using tuned thresholds. Returns record types, responses and process context for investigation; these features alone do not prove tunneling or command and control.

//Category
Threat Hunting / DNS

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{DNS_QUERY_EVENTS}}
| alter
    event_time = {{DNS_TIME}},
    endpoint_id = {{DNS_ENDPOINT_ID}},
    process_id = {{DNS_PROCESS_INSTANCE}},
    query_name = {{DNS_QUERY_NAME}},
    base_domain = {{DNS_BASE_DOMAIN}},
    query_type = {{DNS_QUERY_TYPE}},
    response_code = {{DNS_RESPONSE_CODE}}
| filter endpoint_id != null and endpoint_id != "" and query_name != null and query_name != "" and base_domain != null
| alter name_length = len(query_name)
| comp count() as dns_event_rows, count_distinct(query_name) as distinct_names, avg(name_length) as mean_name_length, max(name_length) as max_name_length, values(query_type) as query_types, values(response_code) as response_codes, values(process_id) as process_instances by endpoint_id, base_domain
| filter distinct_names >= {{MIN_DISTINCT_NAMES}} and mean_name_length >= {{MIN_MEAN_LENGTH}}
| fields endpoint_id, base_domain, dns_event_rows, distinct_names, mean_name_length, max_name_length, query_types, response_codes, process_instances
| sort desc distinct_names, desc mean_name_length
| limit 1000
