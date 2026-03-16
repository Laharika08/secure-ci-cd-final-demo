import boto3

def lambda_handler(event, context):
    """
    AWS Lambda handler function.

    Args:
    event (dict): Lambda event input.
    context (object): Lambda context.

    Returns:
    dict: CNAME records.
    """
    try:
        # Extract ACM certificate ARN from Lambda event input
        cert_arn = event.get('CertificateArn')
        if not cert_arn:
            return {"error": "CertificateArn not provided in the Lambda input."}

        # Create ACM client in the us-east-1 region
        acm_client = boto3.client('acm', region_name='us-east-1')

        # Describe the certificate to get domain validation options
        certificate = acm_client.describe_certificate(CertificateArn=cert_arn)

        # Log the entire certificate to understand its structure
        print("Certificate Response:", certificate)

        # Extract CNAME records from domain validation options
        cname_records = [option.get('ResourceRecord', {}) for option in certificate.get('Certificate', {}).get('DomainValidationOptions', [])]

        return {"CNAMERecords": cname_records}
    except Exception as e:
        return {"error": str(e)}
