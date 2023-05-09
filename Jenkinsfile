pipeline {
    agent any
    environment {
        TERRAGRUNT_SOURCE = "git@github.com/kubota-ta/tmp-repo"
        TERRAGRUNT_CMD = "terragrunt"
        TERRAGRUNT_ARGS = "envs/cmn/base/"
    }
    stages {
        stage('Terraform Init') {
            steps {
                sh "cd ${env.TERRAGRUNT_ARGS} && ${env.TERRAGRUNT_CMD} init"
            }
        }
        stage('Terraform plan') {
            steps {
                sh "cd ${env.TERRAGRUNT_ARGS} && ${env.TERRAGRUNT_CMD} plan"
            }
        }
    }
}
