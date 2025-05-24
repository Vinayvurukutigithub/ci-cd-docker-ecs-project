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
                    def repoUri = sh(
                        script: "aws ecr describe-repositories --repository-names ${ECR_REPO} --region ${AWS_REGION} --query 'repositories[0].repositoryUri' --output text || echo ''",
                        returnStdout: true
                    ).trim()

                    if (!repoUri) {
                        echo "🛠️ ECR repository not found. Creating it..."
                        sh "aws ecr create-repository --repository-name ${ECR_REPO} --region ${AWS_REGION}"
                        repoUri = sh(
                            script: "aws ecr describe-repositories --repository-names ${ECR_REPO} --region ${AWS_REGION} --query 'repositories[0].repositoryUri' --output text",
                            returnStdout: true
                        ).trim()
                    }

                    env.ECR_URL = repoUri
                    echo "✅ ECR URL: ${env.ECR_URL}"
                }
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_URL}
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${APP_NAME} .
                    docker tag ${APP_NAME}:latest ${env.ECR_URL}:latest
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
                    sh """
                        terraform init
                        terraform apply -auto-approve -var="image_url=${env.ECR_URL}:latest"
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment complete!"
        }
        failure {
            echo "❌ Something went wrong. Cleaning up resources..."
            dir('terraform') {
                // Automatically destroy on failure
                sh """
                    terraform destroy -auto-approve -var="image_url=${env.ECR_URL}:latest"
                """
            }
        }
    }
}

