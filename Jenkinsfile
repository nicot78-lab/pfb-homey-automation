pipeline {
    agent any

    stages {

        stage('Vérification environnement') {
            steps {
                bat 'py --version'
                bat 'git --version'
            }
        }

        stage('Installation des dépendances') {
            steps {
                bat 'py -m pip install -r requirements.txt'
            }
        }

        stage('Tests Robot Framework') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'homey-voyageur',
                        usernameVariable: 'HOMEY_VOYAGEUR_USER',
                        passwordVariable: 'HOMEY_VOYAGEUR_PASSWORD'
                    ),
                    usernamePassword(
                        credentialsId: 'homey-hote',
                        usernameVariable: 'HOMEY_HOTE_USER',
                        passwordVariable: 'HOMEY_HOTE_PASSWORD'
                    )
                ]) {
                    bat 'py -m robot --skip defect --outputdir results tests'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
        }
    }
}