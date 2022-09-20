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
        stage("running config") {
            steps {
                sh 'pwd'
                sh 'ls -la'
                sh 'docker-compose up'
            }
        }
    }
}