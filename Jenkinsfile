pipeline {
    agent any

    environment {
        // Use Tomcat image for building and running your app
        DOCKER_IMAGE = "darsan03/tomcat"  // Change this if you want to use a custom Tomcat image
        DOCKER_TAG = "9.0-${BUILD_NUMBER}"  // Ensure it uses the correct Tomcat version
        SONARQUBE_URL = 'http://34.236.145.115:9000'
        SONARQUBE_TOKEN = credentials('sonarqube-token')
    }

    tools {
        maven 'maven'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/hkhcoder/vprofile-action.git',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build with Maven') {
            steps {
                echo "🔧 Building the project with Maven..."
                sh 'mvn clean package -DskipTests -e -X'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "🔍 Running SonarQube analysis..."
                sh """
                    mvn sonar:sonar \
                    -Dsonar.projectKey=my-project-key \
                    -Dsonar.host.url=${SONARQUBE_URL} \
                    -Dsonar.login=${SONARQUBE_TOKEN}
                """
            }
        }

        stage('Build Docker Image with Tomcat') {
            steps {
                echo "🐳 Building Docker image for Tomcat with your app..."
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} -f Dockerfile .
                """
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
