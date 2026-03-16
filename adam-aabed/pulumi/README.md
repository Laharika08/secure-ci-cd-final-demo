# FastAPI AWS Lambda Deployment with Pulumi

Welcome to the FastAPI AWS Lambda Deployment with Pulumi repository! This guide will walk you through the seamless deployment of your FastAPI application onto AWS Lambda and API Gateway. By leveraging Pulumi's infrastructure-as-code capabilities, you can focus on building your FastAPI application while Pulumi handles the heavy lifting of deployment and configuration management.

## Prerequisites

Before you begin, ensure you have the following prerequisites set up:

- **Pulumi CLI**: Install the Pulumi CLI to manage your infrastructure as code. You can find detailed installation instructions [here](https://www.pulumi.com/docs/get-started/install/).

- **AWS Account**: You need an active AWS account and AWS credentials configured on your local system to create and manage AWS resources. Ensure you have the necessary permissions to create Lambda functions and API Gateway endpoints.

- **Python Environment**: Prepare a Python environment with Pulumi installed. Your Pulumi application logic should be contained in a file named `__main__.py`. Place this file inside a `pulumi` folder in your project directory. This `__main__.py` file will be deployed to AWS Lambda.

## Getting Started: Deploying Your FastAPI Application

1. **Clone the Repository**: Begin by cloning this repository to your local machine using the following command:

   ```shell
   git clone https://github.com/aabed/bimodal-serverless.git
   ```

2. **Navigate to the Project Directory**: Change your working directory to the cloned repository:

   ```shell
   cd bimodal-serverless/pulumi
   ```

3. **Deploy Your Stack**: Execute the Pulumi command to deploy your FastAPI application to AWS Lambda and API Gateway:

   ```shell
   pulumi up
   ```

   Pulumi will guide you through the deployment process. Review the proposed changes, and when prompted, type `yes` to proceed with the deployment.

4. **Access Your FastAPI Application**: Once the deployment is complete, Pulumi will output the URL of your API Gateway endpoint. You can use this URL to access your FastAPI application, which is now hosted on AWS Lambda.

## Customization Options

- **Environment Variables**: Inside the `__main__.py` file, you can modify the environment variables to customize settings such as the log group name and log stream name for CloudWatch Logs. These settings allow you to tailor the deployment to your specific requirements.

- **API Gateway Configuration**: Customize the API Gateway routes and integration settings in the `__main__.py` script to match your application's endpoints. Define routes, methods, and integrations according to your application's API structure.

## Cleaning Up Resources

If you want to remove the deployed infrastructure and resources, you can use the following Pulumi command:

```shell
pulumi destroy
```

Follow the prompts to confirm the deletion of the resources.

## Conclusion

Congratulations! You have successfully deployed your FastAPI application onto AWS Lambda and API Gateway using Pulumi. This infrastructure-as-code approach not only simplifies deployment but also provides version control and collaboration benefits. Explore the power of Pulumi to manage and scale your FastAPI applications effortlessly in the AWS cloud environment.