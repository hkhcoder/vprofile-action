pipeline {
    agent any  // Run on any available agent (can be restricted to master if you prefer)

    environment {
        DOCKER_IMAGE = "darsan03/tomcat"
        DOCKER_TAG = "9.0-${BUILD_NUMBER}"
    }

    tools {
        maven 'maven'  // Assuming Maven is already configured in Jenkins
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Cloning the repository from GitHub..."
                // Using the SSH URL with the credentialsId for SSH key authentication
                git url: 'https://github.com/hkhcoder/vprofile-action.git', branch: 'main', credentialsId: 'github-ssh-credentials'
            }
        }

        stage('Build with Maven') {
            steps {
                echo "🔧 Building the project with Maven..."
                sh 'mvn clean package -DskipTests -e -X'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                echo "📤 Pushing Docker image to DockerHub..."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline succeeded — Image pushed to DockerHub!'
        }
        failure {
            echo '❌ Pipeline failed — Check the logs!'
        }
    }
}
