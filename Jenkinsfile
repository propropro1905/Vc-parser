pipeline {
    agent any

    tools {
        maven "maven3"
    }

    stages {
        stage("Build") {
            steps {
                sh "mvn -version"
                sh "mvn clean install"
            }
        }
        stage ("scan"){
            steps{
                withSonarQubeEnv('sonarqube') { 
                    sh 'mvn clean deploy sonar:sonar'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
