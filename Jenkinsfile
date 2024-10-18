pipeline {
    agent any

    tools {
        maven 'Maven 3.8.1' // Ensure Maven is installed
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the Git repository
                git 'https://github.com/yaashwin/devops-capstone-project.git'
            }
        }
        
        stage('Build with Maven') {
            steps {
                // Grant execute permission to mvnw (if you're using it, otherwise you can omit this line)
                sh 'chmod +x mvnw'
                // Build the project
                sh './mvnw clean package' 
            }
        }
        
        stage('Build Docker Image') {
             steps {
                script {
                    // Build the Docker image and tag it with the Jenkins build ID
                    docker.build("yaashwin06/spring-boot-demo:latest")
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the tagged image
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        // Push the image with the 'latest' tag
                        docker.image("yaashwin06/spring-boot-demo:latest").push("latest")
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key_1']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@ec2-34-239-142-14.compute-1.amazonaws.com "
                        docker pull yaashwin06/spring-boot-demo:latest && 
                        docker stop spring-boot-demo || true && 
                        docker rm spring-boot-demo || true && 
                        docker run -d --name spring-boot-demo -p 8080:8080 yaashwin06/spring-boot-demo:latest"
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
