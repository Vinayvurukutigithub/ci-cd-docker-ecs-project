pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        APP_NAME = "nginx-app"
        ECR_REPO = "${APP_NAME}-repo"
        ECR_URL = ""
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/YOUR_USERNAME/YOUR_REPO.git'
            }
        }

        stage('Set ECR URL') {
            steps {
                script {
                    ECR_URL = sh(
                        script: "aws ecr describe-repositories --repository-names ${ECR_REPO} --region ${AWS_REGION} --query 'repositories[0].repositoryUri' --output text",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $APP_NAME .
                    docker tag $APP_NAME:latest $ECR_URL:latest
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                    docker push $ECR_URL:latest
                '''
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

