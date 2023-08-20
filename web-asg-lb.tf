#------------------------ASG--LC--LB-------------------------------------------------

resource "aws_launch_configuration" "lc_asg" {
  name_prefix                 = "WebServer-LC-"
  image_id                    = "ami-0989fb15ce71ba39e"
  instance_type               = "t3.micro"
  security_groups             = [aws_security_group.i-m-web_sg.id]
  key_name = aws_key_pair.jenkins_key_pair.key_name
  user_data                   = file("./web/user_data.sh")
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nginx" {
  name                 = "ASG-${aws_launch_configuration.lc_asg.name}"
  min_size             = 2
  min_elb_capacity     = 2
  max_size             = 3
  desired_capacity     = 2
  health_check_type    = "ELB"
  launch_configuration = aws_launch_configuration.lc_asg.name
  vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
  load_balancers       = [aws_elb.nginx.name]

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = {
      Name  = "WebServer in ASG"
      Owner = "Ivan M"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_elb" "nginx" {
  name            = "nginx-elb"
  subnets         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
  security_groups = [aws_security_group.i-m-web_sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 20
  }
  tags = {
    Name = "WebServer-Highly-Available-ELB"
  }
}
