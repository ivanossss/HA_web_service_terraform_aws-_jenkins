#------------------------Prometheus-instance-------------------------------------------------

data "aws_iam_policy_document" "prometheus_policy" {
  statement {
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "prometheus_policy" {
  name        = "prometheus_policy"
  description = "A policy that allows Prometheus full access to EC2 instances"
  policy      = data.aws_iam_policy_document.prometheus_policy.json
}

resource "aws_iam_instance_profile" "prometheus_profile_im" {
  name = "prometheus_profile_im"
  role = aws_iam_role.prometheus_role.name
}

resource "aws_iam_role" "prometheus_role" {
  name = "prometheus_role"

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
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prometheus_policy_attachment" {
  role       = aws_iam_role.prometheus_role.name
  policy_arn = aws_iam_policy.prometheus_policy.arn
}

resource "aws_instance" "prometheus" {
  ami             = "ami-0989fb15ce71ba39e"
  instance_type   = "t3.micro"
  subnet_id     = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.prometheus_profile_im.name

  user_data = file("./monitoring/prometheus_configure.sh")

  tags = {
    Name = "Prometheus"
  }
}
