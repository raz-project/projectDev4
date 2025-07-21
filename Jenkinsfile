pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_REGION = 'us-east-1'
        PYTHON_PATH = ''  // will be set dynamically after install
    }

    stages {
        stage('Start') {
            steps {
                bat 'echo Starting pipeline...'
            }
        }

        stage('Install Python') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    script {
                        powershell '''
                            $pythonInstalled = Get-Command python -ErrorAction SilentlyContinue
                            if (-Not $pythonInstalled) {
                                Write-Host "Python is not installed. Installing..."
                                Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.9.6/python-3.9.6.exe -OutFile python-installer.exe
                                Start-Process -FilePath python-installer.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -NoNewWindow -Wait
                                Remove-Item python-installer.exe
                            } else {
                                Write-Host "Python is already installed."
                            }
                            # Find installed python path
                            $pyPath = (Get-Command python).Path
                            Write-Host "Python executable path found at: $pyPath"
                            echo "##vso[task.setvariable variable=PYTHON_PATH]$pyPath"
                        '''
                    }
                }
            }
        }

        stage('Check Python') {
            steps {
                script {
                    // Use the Python path env var or fallback to 'python'
                    def pythonExe = env.PYTHON_PATH ?: 'python'
                    bat """
                        echo Verifying Python installation...
                        where ${pythonExe}
                        ${pythonExe} --version
                    """
                }
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
                    script {
                        def pythonExe = env.PYTHON_PATH ?: 'python'
                        bat "${pythonExe} configrePolicy.py --sg-name git_rule --ingress-rules ssh,http,tcp"
                    }
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
                    script {
                        def pythonExe = env.PYTHON_PATH ?: 'python'
                        bat "${pythonExe} uninstallConfigure.py --sg-name git_rule --ingress-rules ssh,http,tcp"
                    }
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
