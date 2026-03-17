output "jenkins_instance_ip" {
  value = module.infra-jenkins.jenkins_instance_ip
}

output "nexus_instance_ip" {
  value = module.infra-nexus.nexus_instance_ip
}

output "sonar_instance_ip" {
  value = module.infra-sonar.sonar_instance_ip
}
