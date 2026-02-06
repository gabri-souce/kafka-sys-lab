#!/bin/bash

# 1. Verifica se il processo Java di Kafka è attivo
# Se il processo non c'è, è inutile aspettare, usciamo subito con errore.
if ! pgrep -f kafka.Kafka > /dev/null; then
    echo "KAFKA: STOPPED (Processo non trovato)"
    exit 1
fi
echo "KAFKA: RUNNING"

# 2. Verifica registrazione nel cluster con tentativi (Retries)
# Kafka può impiegare del tempo per inizializzare la sessione ZooKeeper.
MAX_RETRIES=10
RETRY_INTERVAL=5

echo "Verifica connessione al cluster (Max $MAX_RETRIES tentativi)..."

for i in $(seq 1 $MAX_RETRIES); do
    # Proviamo a interrogare le API del broker
    /opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server localhost:9092 > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "CLUSTER: CONNECTED (Broker registrato correttamente)"
        exit 0
    fi
    
    echo "Tentativo $i fallito. Il broker non è ancora pronto. Attendo ${RETRY_INTERVAL}s..."
    sleep $RETRY_INTERVAL
done

# Se arriviamo qui, significa che il timeout è scaduto
echo "ERRORE: Kafka è attivo ma non si è registrato nel cluster entro $(($MAX_RETRIES * $RETRY_INTERVAL)) secondi."
exit 1