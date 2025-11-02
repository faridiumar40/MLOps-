pipeline{
    agent any

    stages{
        stage('clining Github repo to Jenkins'){
            steps{
                scripst{
                    echo 'Cloning Github repo to Jenkins...........'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/faridiumar40/MLOps-.git']])
                }
            }
        }
    }

}