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
                    ssh -o StrictHostKeyChecking=no ec2-user@ec2-3-128-182-162.us-east-2.compute.amazonaws.com "
                        # Check if the container is running and stop it if it exists
                        if [ \$(docker ps -q --filter name=spring-boot-demo) ]; then
                            docker stop spring-boot-demo
                        fi

                        # Check if the container exists and remove it if it does
                        if [ \$(docker ps -aq --filter name=spring-boot-demo) ]; then
                            docker rm spring-boot-demo
                        fi
                        
                        # Pull the latest image with the specific build ID and run a new container
                        docker pull naadira/spring-boot-demo:${env.BUILD_ID}
                        docker run -d -p 8080:8080 --name spring-boot-demo naadira/spring-boot-demo:${env.BUILD_ID}
                    "
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
