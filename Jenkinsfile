pipeline {
    agent any
    environment {
        ECR_ID = '829092859139'
        REGION    = 'us-west-2'
    }  
    stages{ 
        stage("verify tooling") {
            steps {
                sh '''
                    docker version
                    docker info
                    docker-compose version
                    curl --version
                    jq --version
                '''
            }
        }
        stage("build") {
            steps {
                sh 'pwd'
                sh 'ls -la'
                sh 'docker build . -t jenkins_task:${env.BUILD_NUMBER}'
            }
        }

        stage('Push to ECR'){
            steps {
                withCredentials([aws(credentialsId: 'my_aws', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                script {
                    docker.withRegistry("https://${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com/jenkins_task", "ecr:${REGION}:my_aws") {
                    sh "docker tag jenkins_task:${env.BUILD_NUMBER} ${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com/jenkins_task:${env.BUILD_NUMBER}"
                    sh "docker push ${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com/jenkins_task:${env.BUILD_NUMBER}"
                    }
                }
                }
            }
        }

        // stage("publishing to ECR") {
        //     steps {
        //         withCredentials(aws[credentialsID: 'my_aws', accessKeyVariable:'AWS_ACCESS_KEY_ID', secretKeyVariable:'AWS_SECRET_ACCESS_KEY'])
        //     }
        // }
    }
}