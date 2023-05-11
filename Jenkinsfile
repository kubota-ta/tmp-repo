pipeline {
    agent any
    environment {
        TERRAGRUNT_CMD = "terragrunt"
        TERRAGRUNT_ARGS = "envs/cmn/base/"
    }
    stages {
      stage("checkout") {
        steps {
          checkout scm
        }
      }
      stage("terraform init") {
        steps {
          sh "cd ${env.TERRAGRUNT_ARGS} && terragrunt init -no-color"
        }
      }
      stage("terraform plan") {
        steps {
          sh "cd ${env.TERRAGRUNT_ARGS} && terragrunt plan -no-color -out=plan.out"
          input message: "Apply Plan?", ok: "Apply"
        }
      }
      stage("terraform apply") {
        steps {
          sh "cd ${env.TERRAGRUNT_ARGS} && terragrunt apply plan.out -no-color"
        }
      }
    }
}
