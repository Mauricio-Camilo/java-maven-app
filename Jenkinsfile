def gv 
pipeline {
    
    agent any
    tools {
        maven 'maven-3.9'
    }

    stages {      
        stage('increment version') {
            steps {
                script {
                    echo 'increment app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                    versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }  
        stage('build app') {
            steps {
               script {
                    echo 'building the application...'
                    sh 'mvn clean package'               
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "docker build -t mauriciocamilo/demo-app:$IMAGE_NAME ."
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh "docker push mauriciocamilo/demo-app:$IMAGE_NAME"                    }
                }
            }
        }    
        stage('deploy') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins-aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws_secret_access_key')
                APP_NAME = 'java-maven-app'
            }
            steps {
                script {
                   echo 'deploying docker image...'
                   sh 'envsubst < Kubernetes/deployment.yaml | kubectl apply -f -'
                   sh 'envsubst < Kubernetes/service.yaml | kubectl apply -f -'

                }
            }
        }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        echo "User: ${USER}"
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'
                        
                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'

                        // Replace '@' in email with '%40' for URL encoding
                        def encodedUser = USER.replace('@', '%40')
                
                        // Set the remote URL using encoded user
                        sh "git remote set-url origin https://${encodedUser}:${PASS}@github.com/Mauricio-Camilo/java-maven-app"

                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        // sh 'git push origin HEAD:jenkins-version'
                    }
                }
            }
        }
    }
}    

