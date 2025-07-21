pipeline {
    agent any

    environment {
        PYTHON_PATH = ''
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/raz-project/projectDev4.git',
                        credentialsId: 'github-raz' // make sure this credential exists in Jenkins
                    ]]
                ])
            }
        }

        stage('Install Python') {
            steps {
                script {
                    // Check for Python executable path - adjust if needed
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
                    bat "\"${env.PYTHON_PATH}\" --version"
                }
            }
        }

        stage('Setup Terraform') {
            steps {
                script {
                    try {
                        bat 'terraform init'
                        bat 'terraform apply -auto-approve'
                    } catch (err) {
                        error "Terraform failed: ${err}"
                    }
                }
            }
        }
    }

    post {
        failure {
            echo 'Build failed, skipping remaining stages.'
        }
    }
}
