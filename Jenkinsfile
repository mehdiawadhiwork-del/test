pipeline {
    agent any

    tools {
        maven 'Maven 3.9.0'
        jdk 'JDK 17'
    }

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        SONAR_TOKEN = credentials('sonar-token')
        IMAGE_NAME = 'aouadhi/banking-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Code récupéré'
            }
        }

        stage('Build') {
            steps {
                echo 'Compilation du projet...'
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'Tests unitaires...'
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Analyse SonarQube...'
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=banking-app \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.token=${SONAR_TOKEN}
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Création du JAR...'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Construction image Docker...'
                script {
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Publication sur DockerHub...'
                script {
                    sh """
                        echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Déploiement...'
                script {
                    sh """
                        docker stop banking-app-container || true
                        docker rm banking-app-container || true
                        docker run -d --name banking-app-container -p 8080:8080 ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline réussi !'
        }
        failure {
            echo 'Pipeline échoué.'
        }
    }
}