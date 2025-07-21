pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
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
                        echo "Python executable not found at ${pyPath}, trying 'where python'..."
                        def wherePython = bat(script: 'where python', returnStdout: true).trim()
                        echo "Output of 'where python':\n${wherePython}"
                        if (wherePython) {
                            env.PYTHON_PATH = wherePython.split('\r\n')[0]
                            echo "Using Python path from 'where python': ${env.PYTHON_PATH}"
                        } else {
                            error("Python executable could not be found.")
                        }
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
                // Your terraform init/apply steps here
                echo "Setup Terraform stage placeholder"
            }
        }

        // Add your other stages as needed
    }
}
