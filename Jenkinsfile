pipeline {
    agent any
    environment {
        HOST_IP = '52.89.43.73'
    }  
    
    stages{ 
        stage("verify tooling") {
            steps {
                sh '''
                    env
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
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'sudo whoami'"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com'"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker pull ${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com/jenkins_task:${env.BUILD_NUMBER}'"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker run -it -d -p 3000:80 ${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com/jenkins_task:${env.BUILD_NUMBER}'"
                }
            }
        }                   
                    // sh "ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker rm -f $(docker ps -a -q)'"
                    // sh "ssh -o StrictHostKeyChecking=no ubuntu@52.89.43.73 'docker rmi $(docker images -q)'"
