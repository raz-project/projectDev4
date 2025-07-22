pipeline {
    agent any

    environment {
        // Initialize PYTHON_PATH as empty, will be set in the pipeline
        PYTHON_PATH = ''
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Python') {
            steps {
                script {
                    // Capture the full path to python.exe
                    def pythonPath = bat(script: 'where python', returnStdout: true).trim()
                    if (!pythonPath) {
                        error 'Python executable not found on PATH!'
                    }
                    echo "Python executable path found at: ${pythonPath}"
                    env.PYTHON_PATH = pythonPath
                }
            }
        }

        stage('Check Python') {
            steps {
                script {
                    if (!env.PYTHON_PATH) {
                        error 'PYTHON_PATH environment variable not set!'
                    }
                    // Run python --version using the full path
                    bat "\"${env.PYTHON_PATH}\" --version"
                }
            }
        }

        stage('Setup Terraform') {
            steps {
                echo 'Terraform setup steps go here.'
                // Add your terraform init commands
                // Example: bat 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Terraform apply steps go here.'
                // Add your terraform apply commands
                // Example: bat 'terraform apply -auto-approve'
            }
        }
    }

    post {
        failure {
            echo 'Build failed, skipping remaining stages.'
        }
    }
}

