pipeline {
    agent any

    tools {
        maven 'Maven 3' 
        JDK_21 'Java 21'   
    }

    environment {
        TOMCAT_IP = '34.224.51.100'
        TOMCAT_USER = 'tomcat'
        WAR_FILE = 'target/hello-world.war'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['tomcat-ssh-key']) {
                    sh """
                        scp -o StrictHostKeyChecking=no ${WAR_FILE} ec2-user@${TOMCAT_IP}:/tmp/
                        ssh -o StrictHostKeyChecking=no ec2-user@${TOMCAT_IP} "sudo mv /tmp/hello-world.war /opt/tomcat/webapps/ && sudo systemctl restart tomcat"
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                sh "curl -f http://${TOMCAT_IP}:8080/hello-world/ || exit 1"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
