pipeline {
    agent any
    environment {
        TERRAGRUNT_SOURCE = "git@github.com:kubota-ta/tmp-repo.git"
        TERRAGRUNT_CMD = "terragrunt"
        TERRAGRUNT_ARGS = "envs/cmn/base/"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                sh "cd ${env.TERRAGRUNT_ARGS} && ${env.TERRAGRUNT_CMD} init"
            }
        }
    }
}
