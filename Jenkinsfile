//@Library('javahome-libs') _
currentBuild.displayName = "my-app-java-#"+currentBuild.number
pipeline{
    agent any
    tools{
        maven 'maven-3'
    }
    environment {
      DOCKER_TAG = getVersion()
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
        stage("Docker Build"){
            steps{
                sh 'docker build . -t tafaracheteni/my-app:${DOCKER_TAG}'
            }
        
        }
        //stage("Docker Build"){
        //    steps{
        //        sh 'docker build . -t rancher:5000/my-app:${DOCKER_TAG}'
        //    }
        //}
        //stage("Docker Push"){
        //    steps{
        //          sh 'docker push rancher:5000/my-app:${DOCKER_TAG}'     
        //    }
        //}
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
        stage("Deploy to K8s"){
            steps{
                sh 'chmod +x changeTag.sh'
                sh './changeTag.sh ${DOCKER_TAG}'
                sh 'rm -rf k8s/deployment.yml'
                ansiblePlaybook credentialsId: 'ran1', disableHostKeyChecking: true, installation: 'ansible', inventory: 'dev.int', playbook: 'ansi-file.yml'
            }
        }
        //stage("Deploy to k8s"){
        //    steps{
        //    sh 'chmod +x changeTag.sh'
        //    sh './changeTag.sh ${DOCKER_TAG}'
        //    sh 'scp src/deployment1.yml src/services.yml tafara@192.168.122.90:/home/tafara/'
                
        //        sshagent(['rancher-tafara']) {
        //            sh 'scp -o StrictHostKeyChecking=no src/deployment1.yml src/services.yml tafara@192.168.122.90:/home/tafara/k8s'
        //            script{
        //                try{
        //                    sh 'ssh tafara@192.168.122.90 kubectl apply -f .'
        //                }catch(error){
        //                    sh 'ssh tafara@192.168.122.90 kubectl create -f .'
        //                }
        //            }
        //        }   
        //    }
        //}
    }
    post{
        //always{
            //mail to: "tafaracheteni@gmail.com",
            //subject: "Test Email",
            //body: "Test"
       // }
        
        //always{
            //emailext to: "tafaracheteni@gmail.com",
            //subject: "Test Email",
            //body: "Test",
            //attachLog: true
        //}
        
        failure{
            emailext to: "tafaracheteni@gmail.com",
            subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
            body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
        }
        
        //changed{
            //emailext to: "tafaracheteni@gmail.com",
            //subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
            //body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
        //}
    }
}

def getVersion(){
    def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
