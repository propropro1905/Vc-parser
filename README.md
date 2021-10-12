# Vc-parser
Simple app for parsing vc-language, a self-defined program language similar to C/C++

# docker-compose:
Run docker-compose up to deploy jenkins, sonarqube and nexus via docker-compose file
The urls of those services:
- Jenkins: 192.168.75.132:8080
- SonarQube: 192.168.75.132:9000
- Nexus: 192.168.75.132:8081

#Jenkins
Config jenkins admin and add these plugin:
	
- Pipeline Maven Integration Plugin (name 'maven3')
- SonarQube Scanner for Jenkins: 
- Nexus Artifact Uploader
- Pipeline Utility Steps

# Sonar
We need login token for jenkins to login into sonar
- Go to User > My Account > Security and generate new token use for login 
- Back to Jenkins > Configuration System > SonarQube server
- Add sonar url, name 'sonarqube' add new credential with secret text type and input login token that we generated earlier in sonar.

# Nexus
- Login nexus and config admin
- Create new user name jenkins-user and password
- Create new repo name vc-project > maven2(hosted)
- In Jenkins add credential for jenkins-user

Run pipeline with jenkinsfile within this repo
