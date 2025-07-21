pipeline {
  agent any
  environment {
    PYTHON_PATH = ''
  }
  stages {
    stage('Checkout Code') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/raz-project/projectDev4.git', credentialsId: 'github-raz']]])
      }
    }
    stage('Install Python') {
      steps {
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
          powershell '''
            $pythonInstalled = Get-Command python -ErrorAction SilentlyContinue
            if (-Not $pythonInstalled) {
              Write-Host "Python not found. Installing..."
              Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.9.6/python-3.9.6.exe -OutFile python-installer.exe
              Start-Process -FilePath python-installer.exe -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -NoNewWindow -Wait
              Remove-Item python-installer.exe
            } else {
              Write-Host "Python is already installed."
            }
            $pyPath = (Get-Command python).Source
            Write-Host "Python executable path found at: $pyPath"
            echo "##vso[task.setvariable variable=PYTHON_PATH]$pyPath"
          '''
        }
      }
    }
    stage('Check Python') {
      steps {
        script {
          env.PYTHON_PATH = env.PYTHON_PATH ?: 'C:\\Program Files (x86)\\Python39-32\\python.exe'
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
        // Remove catchError here to expose failures
        bat '''
          terraform --version
          terraform init
        '''
      }
    }
    stage('Terraform Init & Apply - first-thing-before-start') {
      steps {
        bat '''
          terraform apply -auto-approve
        '''
      }
    }
    stage('Run Python Script - tf-security-group') {
      steps {
        dir('modules/tf-security-group') {
          bat '"%PYTHON_PATH%" configurePolicy.py --sg-name git_rule --ingress-rules ssh,http,tcp'
        }
      }
    }
    // add other stages similarly without catchError to catch errors early
  }
}
