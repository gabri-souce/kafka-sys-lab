#!/bin/bash

# 1. Verifica se il processo Java di Kafka è attivo
if ! pgrep -f kafka.Kafka > /dev/null; then
    echo "KAFKA: STOPPED (Processo non trovato)"
    exit 1
fi
echo "KAFKA: RUNNING"

# 2. Percorso del file di configurazione SASL per l'autenticazione
# Questo file viene creato da Ansible in /opt/kafka/config/client-admin.properties
AUTH_CONFIG="/opt/kafka/config/client-admin.properties"

# 3. Verifica registrazione nel cluster con tentativi (Retries)
MAX_RETRIES=10
RETRY_INTERVAL=5

echo "Verifica connessione al cluster con autenticazione SASL..."

for i in $(seq 1 $MAX_RETRIES); do
    # Eseguiamo il comando passando il file delle credenziali admin
    /opt/kafka/bin/kafka-broker-api-versions.sh \
        --bootstrap-server localhost:9092 \
        --command-config "$AUTH_CONFIG" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "CLUSTER: CONNECTED (Autenticazione riuscita e Broker registrato)"
        exit 0
    fi
    
    echo "Tentativo $i: Broker non pronto o autenticazione in corso... Attendo ${RETRY_INTERVAL}s"
    sleep $RETRY_INTERVAL
done

echo "ERRORE: Impossibile connettersi al cluster SASL entro il timeout."
echo "Controlla i log con: journalctl -u kafka"
exit 1