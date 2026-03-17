def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]
pipeline {
    
	agent any

	tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }

    environment {
        SNAP_REPO = "bimodal-snapshot"
        RELEASE_REPO = "bimodal-release"
        CENTRAL_REPO = "bimodal-maven-central"
        NEXUSIP = '172.31.24.199'
        NEXUSPORT = '8081'
        NEXUS_GRP_REPO = "bimodal-maven-group"
        NEXUS_LOGIN = "nexuslogin"
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "172.31.24.199:8081"
	    NEXUS_REPOGRP_ID    = "bimodal-maven-group"
        SONARSERVER = "sonarserver"
        SONARSCANNER = "sonarscanner"
    }
	
    stages{
        
        stage('Setup Environment') {
            steps {
                script {
                  // Inject Nexus Credentials Securely from Jenkins Credentials Manager
                  withCredentials([usernamePassword(credentialsId: "${NEXUS_LOGIN}", usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    env.NEXUS_USER = "${NEXUS_USER}"
                    env.NEXUS_PASS = "${NEXUS_PASS}"
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                echo 'Cleaning up Maven cache and previous builds...'
                // Clean target directory
                sh 'mvn clean'
                // Optionally remove local dependencies cache (force Maven to re-download dependencies)
                sh 'rm -rf ~/.m2/repository'
            }
        }

        stage('BUILD'){
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('UNIT TEST'){
            steps {
                sh 'mvn -s settings.xml test'
            }
        }
        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn -s settings.xml checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Checkstyle Analysis done successfully'
                }
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofilename \
                    -Dsonar.projectName=vprofile \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/classes/ \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPath=target/checkstyle-result.xml
                    '''
                }
            }
        }

        stage('Quality Gate'){
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Upload to Nexus'){
            steps {
              nexusArtifactUploader(
                nexusVersion: 'nexus3',
                protocol: 'http',
                nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                groupId: 'QA',
                version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                repository: "${RELEASE_REPO}",
                credentialsId: "${NEXUS_LOGIN}",
                artifacts: [
                    [artifactId:'vproapp',
                     classifier: '',
                     file: 'target/vprofile-v2.war',
                     type: 'war']
                ]
              )        
            }
        }
    }
      post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#jenkinscicd', 
              color: COLOR_MAP[currentBuild.currentResult],
              message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
  }
}