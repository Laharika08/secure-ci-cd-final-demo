import boto3

def lambda_handler(event, context):
    acm = boto3.client('acm', region_name='us-east-1')  # ACM certificate created in us-east-1

    params = {
        'DomainName': event['DomainName'],
        'ValidationMethod': 'DNS',
    }

    try:
        result = acm.request_certificate(**params)
        certificate_arn = result['CertificateArn']
        # Add other relevant data

        print('ACM Certificate Requested:', result)

        # You can return relevant information if needed
        return {
            'certificateArn': certificate_arn,
            # Add other relevant data
        }
    except Exception as e:
        print('Error requesting ACM Certificate:', str(e))
        raise e
