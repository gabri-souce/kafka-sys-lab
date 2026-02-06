#!/bin/bash
# Verifica se il processo è attivo
if pgrep -f kafka.Kafka > /dev/null; then
    echo "KAFKA: RUNNING"
else
    echo "KAFKA: STOPPED"
    exit 1
fi

# Verifica se il broker è registrato in ZooKeeper
/opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server localhost:9092 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "CLUSTER: CONNECTED"
else
    echo "CLUSTER: NOT REGISTERED"
    exit 1
fi