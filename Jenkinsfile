pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')       // set your Jenkins AWS credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/raz-project/projectDev4.git', 
                    credentialsId: 'github-raz'  // Your Jenkins GitHub credentials ID
            }
        }

        stage('Setup Terraform') {
            steps {
                // Install Terraform (for Ubuntu agents) - you might want a docker or pre-installed version
                sh '''
                    wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
                    unzip terraform_1.6.6_linux_amd64.zip
                    sudo mv terraform /usr/local/bin/
                    terraform version
                '''
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
                        python3 configrePolicy.py --sg-name git_rule --ingress-rules ssh,http,tcp
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

        stage('Run Python Script - uninstall SG') {
            steps {
                dir('modules/tf-security-group') {
                    sh '''
                        python3 uninstallConfigure.py --sg-name git_rule --ingress-rules ssh,http,tcp
                    '''
                }
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
