pipeline {
    agent any
    
    environment {
        // Disabilita il controllo dell'impronta SSH per evitare blocchi
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Pull Code') {
            steps {
                // Scarica il codice dal repository Git configurato
                checkout scm
            }
        }

        stage('Deploy Infrastructure') {
            steps {
                // Esegue il playbook Ansible per configurare il cluster
                sh 'ansible-playbook -i ansible/inventory.ini ansible/deploy_kafka.yml --private-key /var/jenkins_home/.ssh/id_rsa -u kadmin'
            }
        }

        stage('Verify Health') {
            steps {
                script {
                    def nodes = ['192.168.52.128', '192.168.52.129', '192.168.52.130']
                    
                    echo "Inizio verifica salute cluster su tutti i nodi..."
                    
                    for (node in nodes) {
                        echo "Controllo nodo: ${node}"
                        // Usiamo 'sudo' perché lo script deve leggere i file in /opt/kafka/config/ che sono 0600 o 0644
                        // kadmin ha i permessi sudo senza password impostati nella Fase 1
                        sh "ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/.ssh/id_rsa kadmin@${node} 'sudo /usr/local/bin/kafka-health'"
                    }
                    
                    echo "Tutti i nodi sono operativi e autenticati correttamente!"
                }
            }
        }
    }
}