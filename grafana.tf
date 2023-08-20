#------------------------Grafana-instance-------------------------------------------------

# Экземпляр EC2 для Grafana
resource "aws_instance" "grafana" {
  ami             = "ami-0989fb15ce71ba39e" 
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.prometheus_profile_im.name
  key_name = aws_key_pair.jenkins_key_pair.key_name

  user_data = file("./monitoring/grafana_configure.sh")

  provisioner "file" {
    source      = "./monitoring/grafana/"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.jenkins_private_key.private_key_pem
      host        = self.public_ip
    }
  }

  depends_on = [aws_instance.prometheus] # Зависимость от инстанса Prometheus

  tags = {
    Name = "Grafana"
  }
}