pipeline {
    agent any

    tools {
        maven 'Maven 3.8.1' // Ensure Maven is installed
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Naadira/devops-capstone-project.git'
            }
        }
        
        stage('Build with Maven') {
            steps {
                // Grant execute permission to mvnw
                sh 'chmod +x mvnw'
                sh './mvnw clean package'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("spring-boot-demo:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("spring-boot-demo:${env.BUILD_ID}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh ec2-user@<your-ec2-instance-ip> "docker pull your-dockerhub-username/spring-boot-demo:latest && docker run -d -p 8080:8080 your-dockerhub-username/spring-boot-demo:latest"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
