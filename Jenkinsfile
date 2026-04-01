pipeline {
    agent any
    environment {
        IMAGE_NAME = "murthy4797/javaproject"
        REGISTRY_CREDENTIALS = "docker-credentials"
    }
    

    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Murthyklg/javaproject.git'
            }
        }
        //check if docker is runnning properly. If not working properly, pipeline breaks here
        stage('test docker'){
            steps {
        sh 'docker ps'
            }
        }
       
//stage where commit id is trimmed till 7 characters and taken for reference
        stage('Get Commit SHA') {
            steps {
                script {
                    COMMIT_SHA = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()
                }
            }
        }
//build docker image with image id as build-build.id-commit.SHA which gives unique docker image everytime a build is triggered
        stage('Build Docker Image') {
            steps {
                  script {
            IMAGE_TAG = "build-${BUILD_NUMBER}-${COMMIT_SHA}"
            echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
            dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
        }
            }
        }
//tag the last built image as latest
        stage('Tag Latest Image') {
    		steps {
      		    script {
            // Get the most recently created image for this repo
            		def LAST_IMAGE_TAG = sh(
                		script: "docker images ${IMAGE_NAME} --format '{{.Tag}}' | head -n 1",
               				 returnStdout: true
            				).trim()
            			echo "Last image tag: ${LAST_IMAGE_TAG}"
            // Tag it as latest
            		sh "docker tag ${IMAGE_NAME}:${LAST_IMAGE_TAG} ${IMAGE_NAME}:latest"
        		}
    		}
	}
//delete running container before running new latest image
stage('Cleanup Old Container') {
   steps {
       script {
           sh '''
          docker ps -q --filter "publish=8086" | xargs -r docker stop
           docker ps -aq --filter "publish=8086" | xargs -r docker rm
         '''
       }
   }
}
// run the docker conainer
    /*    stage('run docker container'){
           * steps{
          *      sh 'docker run -d -p 8086:8080 murthy4797/javaproject:latest'
        *    }
        } */
        // push image to docker hub
        stage('Push Docker Image') {
    steps {
        script {
            def IMAGE_NAME = "murthy4797/javaproject"

            withDockerRegistry([credentialsId: 'docker-credentials', url: 'https://index.docker.io/v1/']) {
                sh """
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${IMAGE_NAME}:latest
                """
            }
        }
    }
}
//deploy to kubernetes
       stage('Deploy to Kubernetes') {
    steps {
        withCredentials([file(credentialsId: 'javaproject-kubeconfig', variable: 'KUBECONFIG')]) {
            sh '''
            export KUBECONFIG=$KUBECONFIG
            echo "Using kubeconfig:"
            kubectl config current-context
            kubectl get nodes
            kubectl apply -f k8s/
            '''
        }
    }
}
    }
}
