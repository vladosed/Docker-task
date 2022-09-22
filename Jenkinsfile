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
        stage("Preparation") {
            steps {
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage("Build") {
            steps{
                script {
                    dockerImage = docker.build "jenkins_task:${env.BUILD_NUMBER}"
                }
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

        stage('Connect to instance & deploy from ecr') {
            steps{
                sshagent(credentials: ['test_instance']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'sudo whoami'
                        ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 829092859139.dkr.ecr.us-west-2.amazonaws.com'
                        ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker build -t jenkins_task .'
                        ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker tag jenkins_task:${env.BUILD_NUMBER} ${ECR_ID}.dkr.ecr.us-west-2.amazonaws.com/jenkins_task:latest'
                        ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker push ${ECR_ID}.dkr.ecr.us-west-2.amazonaws.com/jenkins_task:${env.BUILD_NUMBER}'
                    '''
                }
            }
        }
                        // sudo whoami
                        // aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 829092859139.dkr.ecr.us-west-2.amazonaws.com
                        // docker pull 829092859139.dkr.ecr.us-west-2.amazonaws.com/jenkins_task:${env.BUILD_NUMBER}
        // stage("publishing to ECR") {
        //     steps {
        //         withCredentials(aws[credentialsID: 'my_aws', accessKeyVariable:'AWS_ACCESS_KEY_ID', secretKeyVariable:'AWS_SECRET_ACCESS_KEY'])
        //     }
        // }
    }
}