pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        APP_NAME = "nginx-app"
        ECR_REPO = "nginx-app-repo"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Vinayvurukutigithub/ci-cd-docker-ecs-project.git'

            }
        }

        stage('Set ECR URL') {
            steps {
                script {
                    env.ECR_URL = sh(
                        script: "aws ecr describe-repositories --repository-names ${env.ECR_REPO} --region ${env.AWS_REGION} --query 'repositories[0].repositoryUri' --output text",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_URL}
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${env.APP_NAME} .
                    docker tag ${env.APP_NAME}:latest ${env.ECR_URL}:latest
                """
            }
        }

        stage('Push to ECR') {
            steps {
                sh "docker push ${env.ECR_URL}:latest"
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment complete!"
        }
        failure {
            echo "❌ Something went wrong."
        }
    }
}

