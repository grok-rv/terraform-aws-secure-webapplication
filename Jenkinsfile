//----Jenkinsfile---------------

import groovy.json.JsonOutput
env.terraform_version = '0.12.2'
pipeline {

   parameters {
    choice(name: 'action', choices: 'create\ndestroy', description: 'Create/update or destroy the eks cluster.')
    string(name: 'aws_region', defaultValue : 'us-west-2', description: "AWS region.")
    string(name: 'env', defaultValue: 'la', description: "lab environment")
    string(name: 'rolename', defaultValue: 'aws-jenkins', description: "default aws role for jenkins")
    string(name: 'role-account', defaultValue: '114622770664', description: "default aws role account for jenkins")
    string(name: 'cluster', defaultValue: 'twistlock-eks-terraform', description: "eks cluster name")
    string(name: 'cidrblock', defaultValue : '10.123.0.0/16', description: "First 2 octets of vpc network; eg 10.0")
    string(name: 'cidr_public', defaultValue: '["10.123.1.0/24","10.123.2.0/24"]', description: "cidr block for public subnets")
    string(name: 'cidr_private', defaultValue: '["10.123.3.0/24","10.123.4.0/24"]', description: "cidr block for private subnets")
    string(name: 'count', defaultValue : '2', description: "Number of vpc subnets/AZs.")
    //string(name: 'credential', defaultValue : 'aws-jenkins', description: "Jenkins credential that provides the AWS access key and secret.")
    string(name: 'accessIp', defaultValue: '0.0.0.0/0', description: "cidr block for bastion host restrict to your ip or vpn")
    string(name: 'instancetype', defaultValue: 't2.micro', description: "instance type for ec2")
    string(name: 'keyname', defaultValue: 'tfs-key', description: "keyname to be used for ssh access to ec2 vm")
    string(name: 'publickeypath', defaultValue: '~/.ssh/id_rsa.pub', description: "the file path location to your pub key to be passed to ec2 vm")


  }

  options {
    disableConcurrentBuilds()
    timeout(time: 1, unit: 'HOURS')
    //withAWS(credentials: params.credential, region: params.region)
    //ansiColor('xterm')
  }

  agent { label 'master' }

  stages {

    stage('Setup') {
      steps {
        script {
          currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + params.cluster
          plan = params.cluster + '.plan'
        }
      }
    }

    stage('Install dependencies') {
      steps {
        sh "sudo apt install wget zip python-pip -y"
        sh "cd /tmp"
        sh "curl -o terraform.zip https://releases.hashicorp.com/terraform/'$terraform_version'/terraform_'$terraform_version'_linux_amd64.zip"
        sh "unzip terraform.zip"
        sh "sudo mv terraform /usr/bin"
        sh "rm -rf terraform.zip"
        sh "terraform version"
      }
    }

    stage('Git checkout') {
       steps {
         dir('terraform-aws-secure-webapplication') {
           git branch: 'master', credentialsId: 'rv0147-github', url: 'https://github.com/rv0147/terraform-aws-secure-webapplication.git'
         }
       }
    }

    stage('TF Plan') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
          withAWS([profile:${params.env}, region:${params.aws_region}, role:${params.rolename}, roleAccount:${params.role-account}]) {

            // Format cidrs into a list array
            //def ips = '["' + params.accessIp.replaceAll(/\s+/,'\",\"') + '"]'

            sh """
              cd terraform-aws-secure-webapplication
              terraform init
              terraform plan -out ${tfplan}
                //-var cluster-name=${params.cluster} \
                //-var
                //-var cidrblock=${params.cidrblock} \
                //-var vpc-subnets=${params.num_subnets} \
                //-var instancetype=${params.instancetype} \
                //-var num-workers=${params.num_workers} \
                //-var 'api-ingress-ips=${ips}' \
                // -out ${plan}
            """
          }
        }
      }
    }

    stage('TF Apply') {
      when {
        expression { params.action == 'create' }
      }
      steps {
        script {
          input "Create/update Terraform stack eks-${params.cluster} in aws?"

          withAWS([profile:${params.env}, region:${params.aws_region}, role:${params.rolename}, roleAccount:${params.role-account}]) {

            sh """
              cd terraform-aws-secure-webapplication
              terraform apply -input=false -auto-approve ${plan}
            """
          }
        }
      }
    }

    stage('TF Destroy') {
      when {
        expression { params.action == 'destroy' }
      }
      steps {
        script {
          input "Destroy Terraform stack eks-${params.cluster} in aws?"

          withAWS([profile:${params.env}, region:${params.aws_region}, role:${params.rolename}, roleAccount:${params.role-account}]) {

            sh """
              cd terraform-aws-secure-webapplication
              terraform destroy -auto-approve
            """
          }
        }
      }
    }

  }

}
