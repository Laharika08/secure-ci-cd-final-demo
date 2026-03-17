variable "security_group_name" {
  type = string
}

variable "key_pair_name" {
  type = string
}

resource "aws_instance" "pre_hire_nexus_instance" {
  ami           = "ami-0df2a11dd1fe1f8e3"
  instance_type = "t2.medium"
  security_groups = [var.security_group_name]
  key_name        = var.key_pair_name
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Replace with the appropriate user for your AMI
      private_key = file("${path.module}/../security/bimodal-key.pem")  # Path to your private key file
      host        = self.public_ip
    }

    inline = [
      "sudo hostnamectl set-hostname nexus-01",
    ]
  }

  user_data = <<-EOF
    #!/bin/bash
    
    sudo rpm --import https://yum.corretto.aws/corretto.key
    sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
    
    sudo yum install -y java-17-amazon-corretto-devel wget -y
    
    mkdir -p /opt/nexus/   
    mkdir -p /tmp/nexus/                           
    cd /tmp/nexus/
    NEXUSURL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
    wget $NEXUSURL -O nexus.tar.gz
    sleep 10
    EXTOUT=`tar xzvf nexus.tar.gz`
    NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`
    sleep 5
    rm -rf /tmp/nexus/nexus.tar.gz
    cp -r /tmp/nexus/* /opt/nexus/
    sleep 5
    useradd nexus
    chown -R nexus.nexus /opt/nexus 
    cat <<EOT>> /etc/systemd/system/nexus.service
    [Unit]                                                                          
    Description=nexus service                                                       
    After=network.target                                                            
                                                                      
    [Service]                                                                       
    Type=forking                                                                    
    LimitNOFILE=65536                                                               
    ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start                                  
    ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop                                    
    User=nexus                                                                      
    Restart=on-abort                                                                
                                                                      
    [Install]                                                                       
    WantedBy=multi-user.target                                                      
    
    EOT
    
    echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc
    systemctl daemon-reload
    systemctl start nexus
    systemctl enable nexus
    systemctl daemon-reload
    EOF

  tags = {
    Name = "nexus-01"
  }
}
output "nexus_instance_ip" {
  value = aws_instance.pre_hire_nexus_instance.public_ip
}
