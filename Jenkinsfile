pipeline {
  agent any
  environment {
    USERNAME = 'ubuntu'
    SERVER = '172.31.20.83'
  }

  stages {
    stage ('Build Docker Image') {
      when {
        branch 'master'
      }
      steps {
        script {
          app = docker.build('richardluo0506/devops')
        }
      }
    }
    stage('Push Docker Image') {
      when {
        branch 'master'
      }
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("latest")
          }
        }
      }
    }
    stage('Deploy to prod') {
      when {
        branch 'master'
      }
      steps {
        input 'Deploy to production?'
        milestone(1)
        sshagent (credentials: ['5e322410-00af-4ee3-b2ff-6bf5ffd0f194']) {
          script {
            sh "ssh $USERNAME@$SERVER docker ps"
            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull richardluo0506/devops:latest\""
            try {
                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop hello\""
                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm hello\""
            } catch (err) {
                echo: 'caught error: $err'
            }
            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name test -p 8000:8000 -d richardluo0506/test:latest\""
          }
        }
      }
    }
  }
}