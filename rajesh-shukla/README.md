This is my first AWS with Terraform project

This project is to configure 3 tier of application. So it will create a VPC and 2 subnets for application, 2 subnets for frantend like alb and 2 subnets for the db. It will also create one bastian server for accessing the other db and application servers. I will create 2 servers for the application and 1 server for the databases.

    Install Terraform on your local machine.

    Create an IAM user and get the "Access key ID" and "Secret access key"
        Do not get the user full access to everything. Give him access only to the needed resources to ensure your following the least privilege princibles for better security practices.

    Set the keys from step #2 as environementa variables. (Not best practices, I will use other more secure ways to handles secrets later)
        You can also just install AWS CLI and configure you credentials there. (Also, not a best practice but that is what I did for this demo for now).

    After going through the code and changing the variables at your convience, you just need to run the following commands in the project directory:

    terraform init
    terraform plan
    terraform apply

Please note that this is a work on progress. I will keep updating this repo and adding more complex components.

