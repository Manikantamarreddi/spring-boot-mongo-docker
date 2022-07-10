pipeline{
    
    agent any
    
    tools {
  maven 'Maven3.8.6'
}
    
    
    stages{
    stage('Checkout code'){
        steps{
        git 'https://github.com/Manikantamarreddi/spring-boot-mongo-docker.git'
        }
    }
    
    stage('Build'){
        steps{
        sh "mvn clean package"
        }
    }
    
    stage('Install aws CLI'){
        steps{
            sh "pip3 install --user boto3"
            sh "pip3 install --upgrade requests --user"
            //sh "ansible-playbook -i dynamicinventory.aws_ec2.yml docker.yaml -u ubuntu --private-key=hosts.pem"
           // ansiblePlaybook become: true, colorized: true, credentialsId: 'pemfile', installation: 'ansible', inventory: 'dynamicinventory.aws_ec2.yml', playbook: 'docker.yaml'
           ansiblePlaybook become: true, becomeUser: 'root', colorized: true, credentialsId: 'pemfile', disableHostKeyChecking: true, installation: 'ansible', inventory: 'dynamicinventory.aws_ec2.yml', playbook: 'docker.yaml'
           //chmod +x /usr/local/bin/docker-compose
    }
    }
    
    stage('Build image'){
        steps{
            sh "docker build -t 938645488558.dkr.ecr.ap-south-1.amazonaws.com/springapp:$BUILD_NUMBER ."
        }
    }
    
    stage('Authenticate with ECR and push'){
        steps{
        sh "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 938645488558.dkr.ecr.ap-south-1.amazonaws.com"
        sh "docker push 938645488558.dkr.ecr.ap-south-1.amazonaws.com/springapp:$BUILD_NUMBER"
    }
    }
    
    stage('Edit and copy docker-compose file to Deployment_Server'){
        steps{
            sh "sed -i 's/IMAGETAG/${BUILD_NUMBER}/gi' docker-compose.yml"
            sshagent(['pemfile']) {
                sh "scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@172.31.37.72:"
                sh "scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@172.31.4.178:"
}
        }
    }
    
    stage('Deploy to container using docker-compose'){
        steps{
            sshagent(['pemfile']) {
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.37.72 aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 938645488558.dkr.ecr.ap-south-1.amazonaws.com"
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.4.178 aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 938645488558.dkr.ecr.ap-south-1.amazonaws.com"
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.37.72 docker-compose up -d"
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.4.178 docker-compose up -d"
}
        }
    }
    }
}
