//@Library('javahome-libs') _
pipeline{
    agent any
    tools{
        maven 'maven3'
    }
    environment {
      DOCKER_TAG = 'getVersion()'
    }

    stages{
        stage("Create Folder"){
            steps{
                sh "mkdir -p ${env.JOB_NAME}"
            }
        }
        stage("Maven Build"){
            steps{
                sh 'mvn clean package'
            }
        }
        stage("SonarQube Analysis"){
            steps{
                withSonarQubeEnv('sonar-6') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage("Email Notification"){
            steps{
                mail bcc: '', body: '''
            Hi Team1

            Your jenkins was successfully executed.

            Regards
            Tafara''', cc: '', from: '', replyTo: '', subject: 'Jenkins Job was successful', to: 'tafaracheteni@gmail.com'
            }
        }
        stage("Slack Notifications"){
            steps{
                 slackSend baseUrl: 'https://hooks.slack.com/services/',
                     channel: '# jenkins-pipeline-demo',
                     color: 'good',
                     message: 'Your jenkins was successfully executed.',
                     teamDomain: 'Chets-Projects', 
                     tokenCredentialId: 'slack-demo'
            }
        }
        //stage("Docker Build"){
        //    steps{
        //        sh 'docker build . -t tafaracheteni/my-app:${DOCKER_TAG}'
        //    }
        //
        //}
        stage("Docker Build"){
            steps{
                sh 'docker build . -t rancher:5000/my-app:${DOCKER_TAG}'
            }
        }
        stage("Docker Push"){
            steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh 'docker login -u tafaracheteni -p ${dockerHubPwd}'
                }
                
                sh 'docker push tafaracheteni/my-app:${DOCKER_TAG}'
            }
        }
        //stage("Deploy to Tomcat Dev"){
        //    steps{
        //        tomcatDeploy('tomcat-dev','ec2-user','172.31.40.104')
        //     }
        //}
    }
}

def getVersion(){
    def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
