pipeline {
    agent any
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }
    stages {
        stage('Pull Code') {
            steps { checkout scm }
        }
        stage('Deploy Infrastructure') {
            steps {
                sh 'ansible-playbook -i ansible/inventory.ini ansible/deploy_kafka.yml --private-key /var/jenkins_home/.ssh/id_rsa -u kadmin'
            }
        }
        stage('Verify Health') {
            steps {
                script {
                    def nodes = ['192.168.52.128', '192.168.52.129', '192.168.52.130']
                    for (node in nodes) {
                        echo "Verifica salute su: ${node}"
                        // Non serve lo sleep qui, lo fa già lo script!
                        sh "ssh -o StrictHostKeyChecking=no -i /var/jenkins_home/.ssh/id_rsa kadmin@${node} 'kafka-health'"
                    }
                }
            }
        }
    }
}