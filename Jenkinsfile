pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/raz-project/projectDev4.git', 
                    credentialsId: 'github-raz'
            }
        }

        stage('Install Python') {
            steps {
                script {
                    powershell '''
                        # Check if Python is already installed
                        $pythonInstalled = Get-Command python -ErrorAction SilentlyContinue

                        if (-Not $pythonInstalled) {
                            Write-Host "Python is not installed. Installing..."
                            
                            # Download the Python installer
                            Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.9.6/python-3.9.6.exe -OutFile python-installer.exe

                            # Install Python silently with PATH added
                            Start-Process -FilePath python-installer.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -NoNewWindow -Wait

                            # Clean up the installer
                            Remove-Item python-installer.exe
                        } else {
                            Write-Host "Python is already installed."
                        }
                    '''
                }
            }
        }

        stage('Check Python') {
            steps {
                bat '''
                    echo Verifying Python installation...
                    where python
                    python --version
                '''
            }
        }

        stage('Setup Terraform') {
            steps {
                bat '''
                    curl -o terraform.zip https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_windows_amd64.zip
                    powershell -Command "Expand-Archive -Path terraform.zip -DestinationPath . -Force"
                    move terraform.exe C:\\Windows\\System32\\
                    terraform --version
                '''
            }
        }

        stage('Terraform Init & Apply - first-thing-before-start') {
            steps {
                dir('first-thing-before-start') {
                    bat '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Run Python Script - tf-security-group') {
            steps {
                dir('modules\\tf-security-group') {
                    bat 'configrePolicy.py --sg-name git_rule --ingress-rules ssh,http,tcp'
                }
            }
        }

        stage('Terraform Init & Apply - root') {
            steps {
                bat '''
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Run Python Script - uninstall SG') {
            steps {
                dir('modules\\tf-security-group') {
                    bat 'uninstallConfigure.py --sg-name git_rule --ingress-rules ssh,http,tcp'
                }
            }
        }

        stage('Terraform Destroy - root') {
            steps {
                bat '''
                    terraform destroy -auto-approve
                '''
            }
        }

        stage('Terraform Destroy - first-thing-before-start') {
            steps {
                dir('first-thing-before-start') {
                    bat '''
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
}
