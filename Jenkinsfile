pipeline {
  agent any

  environment {
    NAME = "solar-system-9"
    VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    IMAGE_REPO = "solar-system"
    IMAGE_REGISTRY = "puju3366"
    ARGOCD_TOKEN = credentials('argocd')
    GITEA_TOKEN = credentials('Github')
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
          withDockerRegistry(credentialsId: 'Docker', url: '') {
          sh 'docker push ${IMAGE_REGISTRY}/${IMAGE_REPO}-${NAME}:${VERSION}'
      }
      }  
  }

    stage('Clone/Pull Repo') {
      steps {
        script {
          if (fileExists('Solar-System-Gitops-CD')) {

            echo 'Cloned repo already exists - Pulling latest changes'

            dir("Solar-System-Gitops-CD") {
              sh 'git remote set-url origin https://github.com/puju3366/Solar-System-Gitops-CD.git'
              sh 'git pull origin feature'
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
        dir("Solar-System-Gitops-CD") {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
          sh 'sed -i "s#puju3366.*#${IMAGE_REGISTRY}/${IMAGE_REPO}-${NAME}:${VERSION}#g" jenkins-demo/deployment.yaml'
          sh 'cat jenkins-demo/deployment.yaml'
        }
      }
    }



  
stage('Checkout') {
   steps {
	   dir("Solar-System-Gitops-CD"){
withCredentials([gitUsernamePassword(credentialsId: 'Github', gitToolName: 'git-tool')]) {
   sh 'git checkout feature'
   sh 'git add -A'
   sh "git commit -am 'Updated image version for Build - \$VERSION'"
   sh 'git push --set-upstream origin feature'
}
	   }
   }
}


        stage('Approve Merge') {
            steps {
                script {
                    // Pause the pipeline and wait for manual approval
                    def userInput = input(
                        id: 'userInput',
                        message: 'Do you want to merge this branch?',
                        parameters: [
                            choice(name: 'APPROVE', choices: 'Yes\nNo', description: 'Approve the merge?')
                        ]
                    )

                    // Check the user's choice
                    if (userInput == 'Yes') {
                        currentBuild.resultIsBetterOrEqualTo('SUCCESS')
                    } else {
                        currentBuild.resultIsWorseOrEqualTo('FAILURE')
                    }
                }
            }
        }
        stage('Merge to Main') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                // Merge the feature branch into the main branch
		dir("Solar-System-Gitops-CD"){
withCredentials([gitUsernamePassword(credentialsId: 'Github', gitToolName: 'git-tool')]) {
   sh 'git checkout main'

		
                sh "git merge feature"
		
                sh "git push"
}
            }
        }
	}
    


    // stage('Raise PR') {
    //   steps {
    //     sh "bash pr.sh"
    //   }
    // } 
  }
}
