import pulumi
import pulumi_aws as aws
import os
import shutil
import glob
from zipfile import ZipFile, ZIP_DEFLATED

def delete_file(file_path):
    try:
        os.remove(file_path)
        print(f"The file '{file_path}' has been successfully deleted.")
    except OSError as e:
        print(f"Error: {e.filename} - {e.strerror}.")

def zip_directory(directory_path, zip_file_path):
    with ZipFile(zip_file_path, 'w' , compression=ZIP_DEFLATED, compresslevel=9) as zipf:
        for folder_name, _, file_names in os.walk(directory_path):
            for file_name in file_names:
                file_path = os.path.join(folder_name, file_name)
                zipf.write(file_path, os.path.relpath(file_path, directory_path))

        # Add main.py to the ZIP archive
        main_py_path = os.path.join(fastapi_app_path, "../main.py")  # Replace this with the path to your main.py file
        zipf.write(main_py_path, 'main.py')

# Example usage
fastapi_app_path = os.path.dirname(__file__)
directory_path = os.path.join(fastapi_app_path, "../venv/lib/python3.11/site-packages/") # Replace this with the path to your directory
zip_file_path = './function.zip'  # Replace this with the desired output ZIP file path

zip_directory(directory_path, zip_file_path)
# Path to the FastAPI application directory (same directory as pulumi-fastapi.py)


# Create a deployment package containing main.py and site-packages
deployment_package =  pulumi.FileArchive("./function.zip")



# Create an IAM Role for Lambda
lambda_role = aws.iam.Role("lambda-role",
    assume_role_policy="""{
        "Version": "2012-10-17",
        "Statement": [{
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }]
    }"""
)

# Attach an AWS managed policy (Basic Lambda Execution Role) to the Lambda role
lambda_role_attach = aws.iam.RolePolicyAttachment("lambda-role-policy",
    policy_arn="arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    role=lambda_role.name
)

# Create a CloudWatch Logs group for Lambda function
log_group = aws.cloudwatch.LogGroup("lambda-log-group",
    name="/aws/lambda/bimodal-function",  # Replace "bimodal-function" with your Lambda function name
    retention_in_days=30,  # You can modify the retention period as needed
)

# Create a Lambda function with the created IAM role and CloudWatch Logs
lambda_function = aws.lambda_.Function("bimodal-function",
    runtime="python3.11",
    handler="main.handler",
    code=deployment_package,
    role=lambda_role.arn,  # Use the ARN of the created IAM role
    environment={
        "variables": {
            "LOG_GROUP_NAME": log_group.name,
            "LOG_STREAM_NAME": "bimodal-function"  # Replace with desired log stream name
        }
    }
)

# Allow API Gateway to invoke the Lambda function
lambda_permission = aws.lambda_.Permission("lambda-permission",
    action="lambda:InvokeFunction",
    function=lambda_function,
    principal="apigateway.amazonaws.com",
)

# Define API Gateway HTTP API
api = aws.apigatewayv2.Api("my-api",
    protocol_type="HTTP",
)

# Define Lambda integration
integration = aws.apigatewayv2.Integration("lambda-integration",
    api_id=api.id,
    integration_type="AWS_PROXY",
    integration_method="POST",
    connection_type="INTERNET",
    integration_uri=lambda_function.invoke_arn,
    payload_format_version="2.0",
    passthrough_behavior="WHEN_NO_MATCH"
)



# Define default route for the HTTP API
route = aws.apigatewayv2.Route("default-route",
    api_id=api.id,
    route_key="ANY /",
    target=integration.id.apply(lambda id: f"integrations/{id}")
    #target=pulumi.Output.all(api.id, integration.id).apply(lambda ids: f"integrations/{ids[1]}"),
)

# Create a deployment for the API Gateway
deployment = aws.apigatewayv2.Deployment("my-api-deployment",
    opts=pulumi.ResourceOptions(depends_on=[lambda_permission, lambda_function]),
    api_id=api.id,
    
)

# Define a stage for the deployment
stage = aws.apigatewayv2.Stage(
    "my-api-stage",
    name="$default",
    api_id=api.id,
    deployment_id=deployment.id,
    description="Prod Stage",
    route_settings=[
        # aws.apigatewayv2.StageRouteSettingArgs(
        #     route_key="ANY /"
        # )
    ]
)


# Export the API Gateway endpoint URL
pulumi.export("url", pulumi.Output.concat(api.api_endpoint))

# Cleanup the zip file
# pulumi.Output.all(stage.name).apply(lambda args: delete_file(zip_file_path))
