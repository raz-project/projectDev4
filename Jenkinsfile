pipeline {
    agent any

    environment {
        PYTHON_PATH = ''  // will be set dynamically
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Python') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    powershell '''
                      Write-Host "Checking for Python executable..."
                      $pyPath = "C:\\Program Files (x86)\\Python39-32\\python.exe"
                      if (Test-Path $pyPath) {
                        Write-Host "Python executable found at: $pyPath"
                        Write-Host "##vso[task.setvariable variable=PYTHON_PATH]$pyPath"
                      } else {
                        Write-Error "Python executable not found at $pyPath"
                        exit 1
                      }
                    '''
                }
            }
        }

        stage('Check Python') {
            steps {
                script {
                    if (!env.PYTHON_PATH?.trim()) {
                        error("PYTHON_PATH is not set. Aborting pipeline.")
                    }
                    echo "Using Python at: ${env.PYTHON_PATH}"
                }
                bat '''
                    echo Verifying Python installation...
                    where python
                    "%PYTHON_PATH%" --version || exit /b 1
                '''
            }
        }

        stage('Setup Terraform') {
            steps {
                // Run terraform init
                bat 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }

        stage('Run Python Script - tf-security-group') {
            steps {
                dir('modules/tf-security-group') {
                    bat '"%PYTHON_PATH%" configrePolicy.py --sg-name git_rule --ingress-rules ssh,http,tcp'
                }
            }
        }
    }

    post {
        failure {
            echo 'Build failed! Check logs for details.'
        }
    }
}
