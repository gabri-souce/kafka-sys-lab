pipeline {
    agent any
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }
    stages {
        stage('Pull Code') {
            steps {
                checkout scm // Jenkins scarica automaticamente il codice dal repo configurato
            }
        }
        stage('Deploy Infrastructure') {
            steps {
                // Lanciamo il Playbook principale (site.yml)
                sh 'ansible-playbook -i ansible/inventory.ini ansible/deploy_kafka.yml --private-key /var/jenkins_home/.ssh/id_rsa -u kadmin'
            }
        }
        stage('Verify Health') {
            steps {
                // Eseguiamo lo script che abbiamo appena creato su uno dei nodi
                sh 'ssh -i /var/jenkins_home/.ssh/id_rsa kadmin@kafka-1 "kafka-health"'
            }
        }
    }
}