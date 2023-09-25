pipeline {
  agent any

  environment {
    NAME = "solar-system-9"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "solar-system"
    IMAGE_REGISTRY = "puju3366"
    ARGOCD_TOKEN = credentials('argocd')
    GITHUB_TOKEN = credentials('Github')
  }
  
  stages {
    stage('Unit Tests') {
      steps {
        echo 'Implement unit tests if applicable.'
        echo 'This stage is a sample placeholder'
      }
    }

    stage('Build Image') {
      steps {
            sh "docker build -t ${NAME} ."
            sh "docker tag ${NAME}:latest ${IMAGE_REGISTRY}/${IMAGE_REPO}-${NAME}:${VERSION}"
        }
      }

    stage('Push Image') {
      steps {
        withDockerRegistry([ credentialsId: "Docker", url: "" ]) {
          sh 'docker push ${IMAGE_REGISTRY}/${IMAGE_REPO}-${NAME}:${VERSION}'
        }
      }
    }

    stage('Clone/Pull Repo') {
      steps {
        script {
          if (fileExists('argocd')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("argocd") {
          
              sh 'git pull '
            }

          } else {
            echo 'Repo does not exists - Cloning the repo'
            sh 'git clone -b feature https://github.com/puju3366/Solar-System-Gitops-CD.git'
          }
        }
      }
    }            
    
    stage('Update Manifest') {
      steps {
        dir("argocd") {
          sh 'sed -i "s#siddharth6.*#${IMAGE_REGISTRY}/${IMAGE_REPO}-${NAME}:${VERSION}#g" jenkins-demo/deployment.yaml' 
          sh 'cat jenkins-demo/deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {
      steps {
        dir("argocd") {
          sh "git config --global user.email 'bob@controlplane'"
          sh 'git remote set-url origin https://github.com/puju3366/Solar-System-Gitops-CD.git'
          sh 'git checkout feature'
          sh 'git add -A'
          sh 'git commit -am "Updated image version for Build - $VERSION"'
          sh 'git push origin feature'
        }
      }
    }

    stage('Raise PR') {
      steps {
        sh "bash pr.sh"
      }
    } 
  }
}
