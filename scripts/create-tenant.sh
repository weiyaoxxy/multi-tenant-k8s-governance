#!/bin/bash
# Usage: ./scripts/create-tenant.sh team-c

TEAM_NAME=$1
if [ -z "$TEAM_NAME" ]; then
  echo "Usage: $0 <team-name>"
  exit 1
fi

cat << EOF > tenants/${TEAM_NAME}.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: ${TEAM_NAME}
  labels:
    owner: ${TEAM_NAME}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: ${TEAM_NAME}
  name: ${TEAM_NAME}-developer
rules:
- apiGroups: ["", "apps"]
  resources: ["pods", "deployments"]
  verbs: ["get", "list", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${TEAM_NAME}-devs
  namespace: ${TEAM_NAME}
subjects:
- kind: Group
  name: ${TEAM_NAME}-devs@example.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: ${TEAM_NAME}-developer
  apiGroup: rbac.authorization.k8s.io
