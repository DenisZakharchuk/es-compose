#!/bin/bash
# kibana-setup.sh: Create a dedicated user for Kibana and grant all necessary privileges

ES_USER="elastic"
ES_PASS="Qwerty123!"  # <-- Change this to your actual elastic superuser password
ES_URL="https://localhost:9200"
KIBANA_USER="es_kibana"
KIBANA_PASS="Qwerty123!"

# Create a role with required privileges for Kibana system indices
curl -k -u "$ES_USER:$ES_PASS" -X POST "$ES_URL/_security/role/kibana_indices_admin" -H "Content-Type: application/json" -d '{
  "indices": [
    { "names": [".kibana*", ".kibana_task_manager*", ".kibana_security_solution*", ".kibana_alerting_cases*", ".kibana_analytics*", ".kibana_ingest*", ".kibana_usage_counters*"], "privileges": ["all"] }
  ]
}'

# Create the es_kibana user with all necessary roles
curl -k -u "$ES_USER:$ES_PASS" -X POST "$ES_URL/_security/user/$KIBANA_USER" -H "Content-Type: application/json" -d '{
  "password": "'"$KIBANA_PASS"'",
  "roles": ["kibana_admin", "kibana_system", "kibana_indices_admin", "monitoring_user", "ingest_admin", "reporting_user"]
}'

echo "Kibana user $KIBANA_USER created and granted all necessary privileges. Update your docker-compose Kibana environment to use this user."
