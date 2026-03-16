variable "security_group_name" {
  type = string
}

variable "key_pair_name" {
  type = string
}

resource "aws_instance" "pre_hire_jenkins_instance" {
  ami           = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.small"
  security_groups = [var.security_group_name]
  key_name        = var.key_pair_name
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Replace with the appropriate user for your AMI
      private_key = file("${path.module}/../security/bimodal-key.pem")  # Path to your private key file
      host        = self.public_ip
    }

    inline = [
      "sudo hostnamectl set-hostname jenkins-01",
    ]
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install openjdk-11-jdk -y
    sudo apt install maven wget unzip -y
    
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    sudo apt update
    sudo apt install jenkins -y

    sudo systemctl start jenkins
    sudo systemctl enable jenkins

    EOF

  tags = {
    Name = "jenkins-01"
  }
}

output "jenkins_instance_ip" {
  value = aws_instance.pre_hire_jenkins_instance.public_ip
}
