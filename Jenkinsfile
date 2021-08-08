//@Library('javahome-libs') _
pipeline{
    agent any
    tools{
        maven 'maven3'
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
        stage("Email Notification"){
            steps{
                mail bcc: '', body: '''Hi Team

            Your jenkins was successfully executed.

            Regards
            Tafara''', cc: '', from: '', replyTo: '', subject: 'Jenkins Job was successful', to: 'tafaracheteni@gmail.com'
            }
        }
        //stage("Deploy to Tomcat Dev"){
        //    steps{
        //        tomcatDeploy('tomcat-dev','ec2-user','172.31.40.104')
        //     }
        //}
    }
}
