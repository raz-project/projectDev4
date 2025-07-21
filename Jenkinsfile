pipeline {
    agent any

    environment {
        // You can also set a default value here if needed
        PYTHON_PATH = ''
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/raz-project/projectDev4.git'
                        // Add credentials here if needed:
                        // credentialsId: 'github-raz'
                    ]]
                ])
            }
        }

        stage('Install Python') {
            steps {
                script {
                    def pyPath = 'C:\\Program Files (x86)\\Python39-32\\python.exe'
                    if (fileExists(pyPath)) {
                        env.PYTHON_PATH = pyPath
                        echo "Python executable path set to: ${env.PYTHON_PATH}"
                    } else {
                        error("Python executable not found at ${pyPath}")
                    }
                }
            }
        }

        stage('Check Python') {
            steps {
                script {
                    if (!env.PYTHON_PATH) {
                        error("PYTHON_PATH environment variable is not set!")
                    }
                    echo "Verifying Python installation at: ${env.PYTHON_PATH}"
                }
                bat """
                    echo Verifying Python installation...
                    where python
                    "${env.PYTHON_PATH}" --version
                """
            }
        }

        stage('Setup Terraform') {
            steps {
                echo "Setup Terraform stage running..."
                // Add your terraform init/apply commands here
                // For example:
                // bat 'terraform init'
                // bat 'terraform apply -auto-approve'
            }
        }

        // Add other stages as needed...

    }

    post {
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
    }
}
