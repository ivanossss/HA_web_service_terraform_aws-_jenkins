#---------------------------Outputs-------------------------------------------------------

#output "web_lb_url" {
#  value = aws_elb.nginx.dns_name
#}

#output "prometheus_url" {
#  value = "http://${aws_instance.prometheus.public_ip}:9090"  # Вывод ссылки на админку Prometheus
#}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"  # Вывод ссылки на админку jenkins
}
