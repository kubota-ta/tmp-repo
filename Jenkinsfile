pipeline {
    agent any
    environment {
        TERRAGRUNT_SOURCE = "'git@stash.arms.dmm.com:2222/ii_div/kubotat-terraform.git'"
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
