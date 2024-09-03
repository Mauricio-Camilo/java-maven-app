pipeline {
    
    agent any

    stage {
        stage('B=build') {
            steps {
               echo 'building the application...'        
            }
        }
    }
    stage {
        stage('test') {
            steps {
               echo 'testing the application...'        
            }
        }
    }    
    stage {
        stage('deploy') {
            steps {
               echo 'deploying the application...'        
            }
        }
    }    
}
