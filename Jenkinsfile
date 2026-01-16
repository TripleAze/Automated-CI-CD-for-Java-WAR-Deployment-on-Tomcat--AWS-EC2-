pipeline {
    agent any

    tools {
        maven 'Maven 3' 
        jdk 'Java 21'   
    }

    environment {
        TOMCAT_DOMAIN = 'abu-java.chickenkiller.com'
        TOMCAT_USER = 'tomcat'
        WAR_FILE = 'app/target/hello-world.war'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                dir('app') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['tomcat-ssh-key']) {
                    sh """
                        scp -o StrictHostKeyChecking=no ${WAR_FILE} ubuntu@${TOMCAT_DOMAIN}:/home/ubuntu/tmp/
                        ssh -o StrictHostKeyChecking=no ubuntu@${TOMCAT_DOMAIN} "sudo mv /home/ubuntu/tmp/hello-world.war /opt/tomcat/webapps/ && sudo systemctl restart tomcat"
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                echo "Waiting for Tomcat to start..."
                sleep 15
                retry(5) {
                    sh "curl -f https://${TOMCAT_DOMAIN}/hello-world/ || (sleep 10 && exit 1)"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}