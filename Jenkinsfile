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
                emailext body: '''Your jenkins was successfully executed

                Tafara''', subject: 'Jenkins Job was successful', to: 'tafaracheteni@gmail.com; chiduzae@gmail.com'
            }
        }
        //stage("Deploy to Tomcat Dev"){
        //    steps{
        //        tomcatDeploy('tomcat-dev','ec2-user','172.31.40.104')
        //     }
        //}
    }
}
