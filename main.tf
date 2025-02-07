#Create Jenkins instance
module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops.id
  name = "jenkins"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-0f487d954cbe820ef"]
  subnet_id              = "subnet-0f7c76cdf5db0d0b8"
  user_data = file("jenkins-server.sh")

  tags ={
          Name = "jenkins"
        }

    root_block_device = [
       {
        volume_size = 50
        volume_type = "gp3"
        delete_on_termination = true
       }
    ]
}

#Create Jenkins-agent instance
module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops.id
  name = "jenkins-agent"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-0f487d954cbe820ef"]
  subnet_id              = "subnet-0f7c76cdf5db0d0b8"
  user_data = file("jenkins-agent.sh")

  tags ={
          Name = "jenkins-agent"
        }
    
   root_block_device = [
       {
        volume_size = 50     # Size of the root volume in GB
        volume_type = "gp3"  # General Purpose SSD (you can change it if needed)
        delete_on_termination = true    # Automatically delete the volume when the instance is terminated
       }
    ]
}

# #Create SonarQube instance
# module "sonarqube" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.devops.id
#   name = "sonarqube"

#   instance_type          = "t3.small"
#   vpc_security_group_ids = ["sg-0f487d954cbe820ef"]
#   subnet_id              = "subnet-0f7c76cdf5db0d0b8"


#   tags ={
#           Name = "sonarqube"
#         }
    
#    root_block_device = [
#        {
#         volume_size = 50     # Size of the root volume in GB
#         volume_type = "gp3"  # General Purpose SSD (you can change it if needed)
#         delete_on_termination = true    # Automatically delete the volume when the instance is terminated
#        }
#     ]
# }

#Creating records for jenkins
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 3.0"

  zone_name = var.zone_name

  records = [
      {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip,
      ]
      allow_overwrite = true
    },
    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins_agent.private_ip,
      ]
      allow_overwrite = true
    },
    #   {
    #   name    = "sonar-public"
    #   type    = "A"
    #   ttl     = 1
    #   records = [
    #     module.sonarqube.public_ip,
    #   ]
    #   allow_overwrite = true
    # },
    #   {
    #   name    = "sonar-private"
    #   type    = "A"
    #   ttl     = 1
    #   records = [
    #     module.sonarqube.private_ip,
    #   ]
    #   allow_overwrite = true
    # },
  ]
}