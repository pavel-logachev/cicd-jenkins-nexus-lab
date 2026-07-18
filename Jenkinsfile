pipeline {
  agent any

  stages {
    stage('Test') {
      steps {
        sh 'go test .'
      }
    }
    stage('Docker build') {
      steps {
        sh 'docker build -t sdvps-materials:${BUILD_NUMBER} .'
      }
    }
  }
}

