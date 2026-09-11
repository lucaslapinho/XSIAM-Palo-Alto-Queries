//Title
Threat Hunting - Admitted Containers with Privileged or Host-Access Settings

//Description
Selects admitted normal, init and ephemeral container specifications with privileged execution or host-access settings. Requires normalized admitted specs and mounted-volume resolution; a requested privileged spec does not establish admission or a running container.

//Category
Threat Hunting / Kubernetes Workloads

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{ADMITTED_KUBERNETES_CONTAINER_SPECS}}
| alter
    event_time = {{CONTAINER_ADMISSION_TIME}},
    cluster_id = {{CONTAINER_CLUSTER}},
    namespace = {{CONTAINER_NAMESPACE}},
    pod_uid = {{CONTAINER_POD_UID}},
    container_name = {{CONTAINER_NAME}},
    container_kind = {{CONTAINER_KIND}},
    actor = {{CONTAINER_ADMISSION_ACTOR}},
    admitted = {{CONTAINER_ADMITTED_FLAG}},
    privileged = {{CONTAINER_PRIVILEGED}},
    host_pid = {{CONTAINER_HOST_PID}},
    host_ipc = {{CONTAINER_HOST_IPC}},
    host_network = {{CONTAINER_HOST_NETWORK}},
    has_hostpath = {{CONTAINER_HOSTPATH_MOUNT}},
    runtime_id = {{CONTAINER_RUNTIME_ID}}
| filter admitted = true and container_kind in ("normal", "init", "ephemeral")
| filter (privileged = true or host_pid = true or host_ipc = true or host_network = true or has_hostpath = true)
| fields event_time, cluster_id, namespace, pod_uid, container_name, container_kind, actor, privileged, host_pid, host_ipc, host_network, has_hostpath, runtime_id
| sort desc event_time
| limit 1000
