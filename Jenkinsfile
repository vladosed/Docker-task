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
        stage("running congig") {
            steps {
                sh 'docker-compose up'
            }
        }
    }
}