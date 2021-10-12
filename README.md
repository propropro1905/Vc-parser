# Jenkins ci-cd integrate with sonar and nexus for java project
This is a tutorial for simple ci-cd for java project using Jenkins integrate with SonarQube and Nexus

# Source code
The source code is a simple Maven app for parsing vc-language, a self-defined program language similar to C/C++.
This source code can be modify to use in particular case. 

## Set up environment
Run docker-compose up to deploy Jenkins, Sonarqube and Nexus via docker-compose file
The urls of those services:
- Jenkins: 192.168.75.132:8080
- SonarQube: 192.168.75.132:9000
- Nexus: 192.168.75.132:8081


First, config jenkins admin then install these plugins :	
- Pipeline Maven Integration Plugin
- SonarQube Scanner for Jenkins: 
- Nexus Artifact Uploader
- Pipeline Utility Steps

# Integrate SonarQube with Jenkins
We need login token for jenkins to login into sonar
- In Sonar server go to User > My Account > Security and generate new token used for login 
- Back to Jenkins, go to Manage Jenkins > Configuration System > SonarQube Server
- Check the Environment variables box
- Click add SonarQube Server button and fill the url and the name box
- Click add server authentication, choose secret text and add the token generated earlier 
Done. Now we move to config Nexus
# Integrate Nexus withn Jenkins
Login into nexus and config admin account
- Create new user name jenkins-user and password
- Create new repo name vc-project and choose type maven2(hosted)
- In Jenkins, go to Manage > Manage Credentials > Add new Credentials name jenkins-user and password
Now we move to the Pipeline to run Ci-Cd project
# Jenkins Pipeline
- Create new item and choose Pipeline type 
- Go to the Pipeline section
- In the definition box choose Pipeline script from SCm
- We specified the git url and branch of this repo
The content of Jenkins file
First, we define these variables for Pipeline
    agent any

    tools {
        maven "maven3"
    }
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "192.168.75.132:8081"
        NEXUS_REPOSITORY = "vc_project"
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }

The First stage is build the jar file 
    stage("Build") {
        steps {
            sh "mvn -version"
            sh "mvn clean install"
        }
    }
We use the Pipeline Maven Integration Plugin to run mvn command in shell
The Second Stage is Scan the built code in SonarQube using SonarQube Scanner for Jenkins
    stage ("scan"){
        steps{
            withSonarQubeEnv('sonarqube') { 
                sh 'mvn sonar:sonar'
            }
        }
    }

And the last step is pushing the built artifact to nexus

stage("Publish to Nexus Repository Manager") {
    steps {
        script {
            pom = readMavenPom file: "pom.xml";
            filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
            echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
            artifactPath = filesByGlob[0].path;
            artifactExists = fileExists artifactPath;
            if(artifactExists) {
                echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                nexusArtifactUploader(
                    nexusVersion: NEXUS_VERSION,
                    protocol: NEXUS_PROTOCOL,
                    nexusUrl: NEXUS_URL,
                    groupId: pom.groupId,
                    version: pom.version,
                    repository: NEXUS_REPOSITORY,
                    credentialsId: NEXUS_CREDENTIAL_ID,
                    artifacts: [
                        [artifactId: pom.artifactId,
                        classifier: '',
                        file: artifactPath,
                        type: pom.packaging],
                        [artifactId: pom.artifactId,
                        classifier: '',
                        file: "pom.xml",
                        type: "pom"]
                    ]
                );
            } else {
                error "*** File: ${artifactPath}, could not be found";
            }
        }
    }
}
This stage have 2 steps, the first one is extract the information of artifact
in pom.xml file, and the second is pushing artifact to Nexus using those information
and nexusArtifactUploader plugins