data "aws_ami" "devops" {
    most_recent = true
    owners = ["973714476881"]

    filter {
        name = "name" 
        values = ["RHEL-9-DevOps-Practice"]
    }    

    filter {
        name = "root-device-type" 
        values = ["ebs"]
    }
    filter {
        name = "virtualization-type" 
        values = ["hvm"]
    }
}

#ami-0c1a611315833061b
#You need to subscribe SonarQube 
data "aws_ami" "sonarqube" {
    most_recent = true
    owners = ["679593333241"]

    filter {
        name = "name" 
        values = ["SolveDevOps-SonarQube-Server-Ubuntu20.04-20250113-fae7c0cd-e3336ad7-93a2-4e7c-8ed8-227cfbf25da4"]
    }    

    filter {
        name = "root-device-type" 
        values = ["ebs"]
    }
    filter {
        name = "virtualization-type" 
        values = ["hvm"]
    }
}