provider "aws" {
  region = "eu-north-1"
}

provider "tls" {}

#---------------------------Jenkins-key-pair-----------------------------------------------

resource "tls_private_key" "jenkins_private_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = "jenkins_key_pair"
  public_key = tls_private_key.jenkins_private_key.public_key_openssh
}

#---------------------------Jenkins-------------------------------------------------------

resource "aws_instance" "jenkins" {
  ami             = "ami-0989fb15ce71ba39e"
  instance_type   = "t3.micro"
  subnet_id     = aws_subnet.subnet_a.id
  key_name = aws_key_pair.jenkins_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.prometheus_profile.name #Профайл с полным доступом, то что нужно

  user_data = file("./jenkins/jenkins_configure.sh")

#  provisioner "file" {
#    source      = "./jenkins/JCasC.yaml"
#    destination = "/home/ubuntu/JCasC.yaml"

#    connection {
#      type        = "ssh"
#      user        = "ubuntu"
#      private_key = tls_private_key.jenkins_private_key.private_key_pem
#      host        = self.public_ip
#    }
#  }

#  provisioner "file" {
#    source      = "./jenkins/Dockerfile"
#    destination = "/home/ubuntu/Dockerfile"

#    connection {
#      type        = "ssh"
#      user        = "ubuntu"
#      private_key = tls_private_key.jenkins_private_key.private_key_pem
#      host        = self.public_ip
#    }
#  }

  provisioner "file" {
    source      = "./jenkins/"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.jenkins_private_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "Jenkins"
  }
}


