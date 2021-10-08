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
                    sh 'mvn clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'
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
