pipeline {
  agent any

  environment {
    NAME = "solar-system-9"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "solar-system"
    IMAGE_REGISTRY = "puju3366:5000"
    // ARGOCD_TOKEN = credentials('argocd-cred')
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
            sh "docker tag ${NAME}:latest ${IMAGE_REGISTRY}/${IMAGE_REPO}/${NAME}:${VERSION}"
        }
      }

    stage('Push Image') {
      steps {
        withDockerRegistry([credentialsId: "Docker", url: "https://index.docker.io/v1/]) {
          sh 'docker push ${IMAGE_REGISTRY}/${IMAGE_REPO}/${NAME}:${VERSION}'
        }
      }
    }

    stage('Clone/Pull Repo') {
      steps {
        script {
          if (fileExists('gitops-argocd')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("gitops-argocd") {
              sh 'git remote set-url origin http://bob:bob%40123@controlplane:3000/bob/gitops-argocd'
              sh 'git pull'
            }

          } else {
            echo 'Repo does not exists - Cloning the repo'
            sh 'git clone -b feature-gitea http://bob:bob%40123@controlplane:3000/bob/gitops-argocd'
          }
        }
      }
    }
    
    stage('Update Manifest') {
      steps {
        dir("gitops-argocd") {
          sh 'sed -i "s#siddharth67.*#${IMAGE_REGISTRY}/${IMAGE_REPO}/${NAME}:${VERSION}#g" jenkins-demo/deployment.yaml'
          sh 'cat jenkins-demo/deployment.yaml'
        }
      }
    }

    stage('Commit & Push') {
      steps {
        dir("gitops-argocd") {
          sh "git config --global user.email 'bob@controlplane'"
          sh 'git remote set-url origin http://bob:bob%40123@controlplane:3000/bob/gitops-argocd'
          sh 'git checkout feature-gitea'
          sh 'git add -A'
          sh 'git commit -am "Updated image version for Build - $VERSION"'
          sh 'git push origin feature-gitea'
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
