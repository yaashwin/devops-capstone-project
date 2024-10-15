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
                    // Build the Docker image and tag it as 'latest'
                    docker.build("naadira/spring-boot-demo:latest")
                }
            }
        }
        
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the tagged image
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        // Push the image with the 'latest' tag
                        docker.image("naadira/spring-boot-demo:latest").push("latest")
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
                # Stop and remove the existing container if it exists
                docker ps -q --filter "name=spring-boot-demo-container" | xargs -r docker stop
                docker ps -aq --filter "name=spring-boot-demo-container" | xargs -r docker rm

                # Pull the latest Docker image
                docker pull naadira/spring-boot-demo:latest

                # Run the new container
                docker run -d --name spring-boot-demo-container -p 8080:8080 naadira/spring-boot-demo:latest
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
