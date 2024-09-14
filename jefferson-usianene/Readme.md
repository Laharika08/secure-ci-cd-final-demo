# Problem

- There are frequent untested changes being made by developers and this could end up breaking something in the system.

- Not testing code frequently migt lead to an acumulation of bugs and error.

- Sometimes developers are unable or forget to test their code 

- Manual Build & Release proccess

# Solution 

- Build and test every commit
- Automation 
- Notify for every build status
- Fix Error found immediatly 

## Applications Used

- Jenkins 
- GIT
- MAVEN
- Checkstyle (Code Analysis Tool)
- Slack
- Nexus Sonatype (Artifact Software repository)
- sonarqube 
- AWS EC2 Compute
- Terraform

## Objective 

- Fault Isolation
- Short MTTR
- Fast turn around time 
- Less Distruptive

---

## Installation

Installation Tool: Terraform 
Jenkins Server: Ubuntu
Nexus Server: Centos


### AWS CLI Setup

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

- Login

`aws configure`

Auto Destroy Infra Module `terraform destroy -target=module.infra --auto-approve`

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value, InstanceId, State.Name]' --output text

aws ec2 terminate-instances --instance-ids i-014c9c6646f3cc5f0

nexus IP will change any time you reboot the instance (Always update it in the jenkins file)
http://<nexus-server>:8081

Update the jenkins IP on noIP account and access from: http://jenkins.zapto.org:8080

Maven Dependences are defined in the pom.xml file.

Information needed be maven are specified in the settings.xml and the variables in settings.xml are defined in the jenkins file.

> Initiate ssh below and save key to allow ssh access from github to jenkins

Run on jenkins server and confim identity in known hosts

```
git ls-remote -h git@github.com:usianej/vprofile.git HEAD
```
dsd