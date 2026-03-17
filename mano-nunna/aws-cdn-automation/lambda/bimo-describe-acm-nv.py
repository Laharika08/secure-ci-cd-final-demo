import boto3
import json
from json import JSONEncoder
from datetime import datetime

class DateTimeEncoder(JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime):
            return o.isoformat()
        return super().default(o)

def lambda_handler(event, context):
    """
    AWS Lambda handler function.

    Args:
    event (dict): Lambda event input.
    context (object): Lambda context.

    Returns:
    dict: ACM certificate details.
    """
    try:
        # Extract ACM certificate ARN from Lambda event input
        cert_arn = event.get('CertificateArn')
        if not cert_arn:
            return {"error": "CertificateArn not provided in the Lambda input."}

        # Create ACM client in the us-east-1 region
        acm_client = boto3.client('acm', region_name='us-east-1')

        # Describe the ACM certificate
        certificate_details = acm_client.describe_certificate(CertificateArn=cert_arn)

        # Convert datetime objects to strings using custom encoder
        certificate_details["Certificate"] = json.loads(json.dumps(certificate_details["Certificate"], cls=DateTimeEncoder))

        return {"CertificateDescription": certificate_details}
    except Exception as e:
        return {"error": str(e)}
