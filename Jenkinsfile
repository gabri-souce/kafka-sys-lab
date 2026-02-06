pipeline {
    agent any
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }
    stages {
        stage('Pull Code') {
            steps {
                checkout scm
            }
        }
        stage('Deploy Infrastructure') {
            steps {
                sh 'ansible-playbook -i ansible/inventory.ini ansible/deploy_kafka.yml --private-key /var/jenkins_home/.ssh/id_rsa -u kadmin'
            }
        }
        stage('Verify Health') {
            steps {
                echo "Inizio verifica salute cluster su tutti i nodi..."
                
                // Definiamo gli IP dei nostri nodi
                script {
                    def nodes = ['192.168.52.128', '192.168.52.129', '192.168.52.130']
                    
                    for (node in nodes) {
                        echo "Controllo nodo: ${node}"
                        // Se uno di questi fallisce, l'intera pipeline diventerà rossa
                        sh "ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/.ssh/id_rsa kadmin@${node} '/usr/local/bin/kafka-health'"
                    }
                }
                
                echo "Tutti i nodi sono sani e registrati nel cluster!"
            }
        }
    }
}