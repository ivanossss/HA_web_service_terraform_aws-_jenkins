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

resource "aws_iam_policy" "jenkins_policy" {
  name = "jenkins_policy"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "ec2:*",
        Resource = "*",
        Effect = "Allow",
      },
      {
        Action = "autoscaling:*",
        Resource = "*",
        Effect = "Allow",
      },
    ],
  })
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_policy_attachment" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins_instance_profile"
  role = aws_iam_role.jenkins_role.name
}

resource "aws_instance" "jenkins" {
  ami             = "ami-0989fb15ce71ba39e"
  instance_type   = "t3.micro"
  subnet_id     = aws_subnet.subnet_a.id
  key_name = aws_key_pair.jenkins_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.jenkins_instance_profile.name 

  user_data = file("./jenkins/jenkins_configure.sh")

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

  provisioner "file" {
    content     = tls_private_key.jenkins_private_key.private_key_pem
    destination = "/home/ubuntu/my_ssh_key.pem"

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