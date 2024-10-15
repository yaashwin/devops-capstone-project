pipeline {
    agent any

    tools {
        maven 'Maven 3.8.1' // Ensure Maven is installed
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the Git repository
                git 'https://github.com/Naadira/devops-capstone-project.git'
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
                    // Build the Docker image and tag it with the build ID
                    docker.build("naadira/spring-boot-demo:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the tagged image
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        // Push the tagged image to Docker Hub with the build ID tag
                        docker.image("naadira/spring-boot-demo:${env.BUILD_ID}").push("${env.BUILD_ID}")
                    }
                }
            }
        }

        stage('Deploy to EC2') {
    steps {
        sshagent(['ec2-ssh-key_1']) {
            sh '''
                set -e
                ssh -o StrictHostKeyChecking=no ec2-user@ec2-3-128-182-162.us-east-2.compute.amazonaws.com << 'ENDSSH'
                # Your deployment commands here
                docker pull naadira/spring-boot-demo:latest
                # You might want to run a command to stop any existing container first
                # docker stop <container_id> || true
                # docker rm <container_id> || true
                docker run -d -p 8080:8080 naadira/spring-boot-demo:latest
                ENDSSH
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
