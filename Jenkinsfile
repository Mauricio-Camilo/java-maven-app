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
                    -DnewVersion=\\\${parserVersion.majorVersion}.\\\${parserVersion.minorVersion}.\\\${parserVersion.nextIncrementalVersion} \
                    version:commit '
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
            steps {
                script {
                     echo 'deploying docker image...'
                }
            }
        }
    }
}    

