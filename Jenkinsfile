pipeline {
    agent any
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
        stage("running build") {
            steps {
                sh 'pwd'
                sh 'ls -la'
                sh 'docker-compose up -d'
            }
        }
        stage("publishing to ECR") {
            steps {
                script {
                    sh 'docker build -t vladiko'
                    docker.withRegistry(
                        'https://829092859139.dkr.ecr.us-west-2.amazonaws.com/jenkins_task',
                        'ecr:us-west-2:my_aws')
                    def myImage = docker.build('jenkins_task')
                    myImage.push('vladiko')
                }
                // withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_ACCESS_KEY_ID}",
                //  "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}" ]) {
                //      sh 'docker login -u AWS -p $(aws ecr-public get-login-password --region us-east-1) public.ecr.aws/j1h9h4t0'
                //      sh 'for r in $(grep 'image: \${DOCKER_REGISTRY}' docker-compose.yml | sed -e 's/^.*\///') > do > aws ecr create-repository --repository-name "$r" > done'
                //  }
            }
        }
    }
}