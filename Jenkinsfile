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


