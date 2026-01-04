package disallow_privileged

test_privileged_pod_denied {
    input := {
        "apiVersion": "v1",
        "kind": "Pod",
        "spec": {
            "containers": [{
                "name": "bad",
                "image": "nginx",
                "securityContext": {
                    "privileged": true
                }
            }]
        }
    }
    deny with input as input
}

test_non_privileged_pod_allowed {
    not deny with input as {
        "apiVersion": "v1",
        "kind": "Pod",
        "spec": {
            "containers": [{
                "name": "good",
                "image": "nginx"
            }]
        }
    }
}
