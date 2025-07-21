pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/raz-project/projectDev4.git', 
                    credentialsId: 'github-raz'
            }
        }

        stage('Terraform Init & Apply - first-thing-before-start') {
            steps {
                dir('first-thing-before-start') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Run Python Script - tf-security-group') {
            steps {
                dir('modules/tf-security-group') {
                    sh '''
                        python3 configrePolicy.py
                    '''
                }
            }
        }

        stage('Terraform Init & Apply - root') {
            steps {
                sh '''
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Terraform Destroy - root') {
            steps {
                sh '''
                    terraform destroy -auto-approve
                '''
            }
        }

        stage('Terraform Destroy - first-thing-before-start') {
            steps {
                dir('first-thing-before-start') {
                    sh '''
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
}
