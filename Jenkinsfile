pipeline {
    agent any
    stages{
        stage('clone git repo'){
            steps{
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/MohamedAhmedAbdo/flaskapp-database']])
            }
        }
        stage('ECR login'){
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Terraform',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 309705700864.dkr.ecr.us-east-1.amazonaws.com/flask_ecr'
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin  309705700864.dkr.ecr.us-east-1.amazonaws.com/sql_ecr'
                }
            }    
        }    
        stage('Build docker image for flaskapp and MySQL'){
            steps{
    
                sh 'docker build -t 309705700864.dkr.ecr.us-east-1.amazonaws.com/flask_ecr:latest ./flaskapp-database/flaskapp'
                sh 'docker build -t 309705700864.dkr.ecr.us-east-1.amazonaws.com/sql_ecr:latest ./flaskapp-database/mysql'       
            }
        }        
        stage('Push docker image for flask app and MySQL'){
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Terraform',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {

                    sh 'docker push 309705700864.dkr.ecr.us-east-1.amazonaws.com/flask_ecr:latest'
                    sh 'docker push 309705700864.dkr.ecr.us-east-1.amazonaws.com/sql_ecr:latest'
                }   
            }
        }    
        stage('Add EKS kubeconfig') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Terraform',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        
                    sh "aws eks --region us-east-1 update-kubeconfig --name demo"
                }
            }
        }
        stage('Install Ingress Controller') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Terraform',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        
                    sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml'
                }
            }
        }
        stage('Deploy Kubernetes Mainfest') {
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Terraform',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {

                    sh 'kubectl apply -f ./Kubernates/.'
                }
            }
        }
    }
}
