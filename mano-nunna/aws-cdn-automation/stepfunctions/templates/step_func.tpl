{
  "Comment": "Create Distribution  Workflow",
  "StartAt": "CreateDistribution",
  "States": {
    "CreateDistribution": {
    "Type": "Task",
    "Resource": "arn:aws:states:::aws-sdk:cloudfront:createDistribution",
    "Parameters": {
      "DistributionConfig": {
        "CallerReference.$": "$.CallerReference",
        "Aliases": {
            "Quantity": 0
          },
        "DefaultRootObject": "index.html",
        "Origins": {
          "Quantity": 1,
          "Items": [
            {
              "Id.$": "$.Id",
              "DomainName.$": "$.s3domain",
              "OriginPath": "",
              "CustomHeaders": {
                "Quantity": 0
              },
              "S3OriginConfig": {
                "OriginAccessIdentity": "${origin_access_identity}"
              }
            }
          ]
        },
        "OriginGroups": {
          "Quantity": 0
        },
        "DefaultCacheBehavior": {
          "TargetOriginId.$": "$.TargetOriginId",
          "ForwardedValues": {
            "QueryString": false,
            "Cookies": {
              "Forward": "none"
            },
            "Headers": {
              "Quantity": 0
            },
            "QueryStringCacheKeys": {
              "Quantity": 0
            }
          },
          "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
          },
          "ViewerProtocolPolicy": "allow-all",
          "MinTTL": 0,
          "AllowedMethods": {
            "Quantity": 2,
            "Items": [
              "HEAD",
              "GET"
            ],
            "CachedMethods": {
              "Quantity": 2,
              "Items": [
                "HEAD",
                "GET"
              ]
            }
          },
          "SmoothStreaming": false,
          "DefaultTTL": 86400,
          "MaxTTL": 31536000,
          "Compress": false,
          "LambdaFunctionAssociations": {
            "Quantity": 0
          },
          "FieldLevelEncryptionId": ""
        },
        "CacheBehaviors": {
          "Quantity": 0
        },
        "CustomErrorResponses": {
          "Quantity": 0
        },
        "Comment":"Bimo-distribution",
        "Logging": {
          "Enabled": true,
          "IncludeCookies": true,
          "Bucket": "${cdn_logs_bucket_endpoint}",
          "Prefix": ""
        },
        "PriceClass": "PriceClass_All",
        "Enabled": true,
        "ViewerCertificate": {
          "CloudFrontDefaultCertificate": true
        },
        "Restrictions": {
          "GeoRestriction": {
            "RestrictionType": "none",
            "Quantity": 0
          }
        },
        "WebACLId": "",
        "HttpVersion": "http2",
        "IsIPV6Enabled": true
      }
    },
    "ResultPath": "$.CreateDistributionResult",
    "Next":"RequestACMCertificate"
    },
    "RequestACMCertificate": {
      "Type": "Task",
      "Resource": "${create_acm_lambda_arn}",
      "Parameters": {
        "DomainName.$": "$.DomainName",
        "ValidationMethod": "DNS"
      },
      "ResultPath": "$.ACMResult",
      "Next": "WaitBeforeGetCertificateCNAMEs"
    },
    "WaitBeforeGetCertificateCNAMEs": {
      "Type": "Wait",
      "Seconds": 10,
      "Next": "GetCertificateCNAMEs"
    },
    "GetCertificateCNAMEs": {
      "Type": "Task",
      "Resource": "${get_crecords_lambda_arn}",
      "Parameters": {
        "CertificateArn.$": "$.ACMResult.certificateArn"
      },
      "ResultPath": "$.CertificateDescription",
      "Next": "SendEmailNotification"
    },
    "SendEmailNotification": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:ses:sendEmail",
      "Parameters": {
        "Source.$": "$.SourceEmail",
        "Destination": {
          "ToAddresses.$": "$.DestinationEmail"
        },
        "Message": {
          "Subject": {
            "Data": "DNS Update Required"
          },
          "Body": {
            "Text": {
              "Data.$": "States.Format('CNAME: {} Value: {}', $.CertificateDescription.CNAMERecords[0].Name, $.CertificateDescription.CNAMERecords[0].Value)"
            }
          }
        }
      },
      "ResultPath": "$.EmailResult",
      "Next": "WaitForCertificateValidation"
    },
    "WaitForCertificateValidation": {
      "Type": "Wait",
      "Seconds": 10,
      "Next": "DescribeCertificate"
    },
    "DescribeCertificate": {
      "Type": "Task",
      "Resource": "${describe_acm_lambda_arn}",
      "Parameters": {
        "CertificateArn.$": "$['ACMResult']['certificateArn']"
      },
      "ResultPath": "$.CertificateDescription",
      "Next": "CheckValidationStatus"
    },
    "CheckValidationStatus": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.CertificateDescription.CertificateDescription.Certificate.DomainValidationOptions[0].ValidationStatus",
          "StringEquals": "PENDING_VALIDATION",
          "Next": "WaitForCertificateValidation"
        }
      ],
      "Default": "CheckCertificateExpirationStatus"
    },
    "CheckCertificateExpirationStatus": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.CertificateDescription.CertificateDescription.Certificate.DomainValidationOptions[0].ValidationStatus",
          "StringEquals": "SUCCESS",
          "Next": "UpdateDistribution"
        }
      ],
      "Default": "RequestACMCertificate"
    },
    "UpdateDistribution": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:cloudfront:updateDistribution",
      "Parameters": {
        "IfMatch.$": "$.CreateDistributionResult.ETag",
        "Id.$": "$.CreateDistributionResult.Distribution.Id",
        "DistributionConfig": {
          "CallerReference.$": "$.CreateDistributionResult.Distribution.DistributionConfig.CallerReference",
          "Aliases": {
            "Quantity": 1,
            "Items.$": "$.domainName"
          },
          "DefaultRootObject": "index.html",
          "Origins": {
            "Quantity": 1,
            "Items": [
              {
                "Id.$": "$.Id",
                "DomainName.$": "$.s3domain",
                "OriginPath": "",
                "CustomHeaders": {
                  "Quantity": 0
                },
                "S3OriginConfig": {
                    "OriginAccessIdentity": "${origin_access_identity}"
                }
              }
            ]
          },
          "OriginGroups": {
            "Quantity": 0
          },
          "DefaultCacheBehavior": {
            "TargetOriginId.$": "$.TargetOriginId",
            "ForwardedValues": {
              "QueryString": false,
              "Cookies": {
                "Forward": "none"
              },
              "Headers": {
                "Quantity": 0
              },
              "QueryStringCacheKeys": {
                "Quantity": 0
              }
            },
            "TrustedSigners": {
              "Enabled": false,
              "Quantity": 0
            },
            "ViewerProtocolPolicy": "allow-all",
            "MinTTL": 0,
            "AllowedMethods": {
              "Quantity": 2,
              "Items": [
                "HEAD",
                "GET"
              ],
              "CachedMethods": {
                "Quantity": 2,
                "Items": [
                  "HEAD",
                  "GET"
                ]
              }
            },
            "SmoothStreaming": false,
            "DefaultTTL": 86400,
            "MaxTTL": 31536000,
            "Compress": false,
            "LambdaFunctionAssociations": {
              "Quantity": 0
            },
            "FieldLevelEncryptionId": ""
          },
          "CacheBehaviors": {
            "Quantity": 0
          },
          "CustomErrorResponses": {
            "Quantity": 0
          },
          "Comment":"BiMo-distribution",
          "Logging": {
            "Enabled": true,
            "IncludeCookies": true,
            "Bucket": "${cdn_logs_bucket_endpoint}",
            "Prefix": ""
          },
          "PriceClass": "PriceClass_All",
          "Enabled": true,
          "ViewerCertificate": {
            "CloudFrontDefaultCertificate": false,
            "MinimumProtocolVersion": "TLSv1.2_2021",
            "SslSupportMethod": "sni-only",
            "CertificateSource": "acm",
            "AcmCertificateArn.$": "$.ACMResult.certificateArn"
          },
          "Restrictions": {
            "GeoRestriction": {
              "RestrictionType": "none",
              "Quantity": 0
            }
          },
          "WebACLId": "",
          "HttpVersion": "http2",
          "IsIPV6Enabled": true
        }
      },
      "ResultPath": "$.UpdateDistributionResult",
      "Next":"CreateAliasRecord"
    },
    "CreateAliasRecord": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:route53:changeResourceRecordSets",
      "Parameters": {
        "HostedZoneId.$": "$.HostedZoneId",
        "ChangeBatch": {
          "Changes": [
            {
              "Action": "CREATE",
              "ResourceRecordSet": {
                "Name.$": "$.DomainName",
                "Type": "A",
                "AliasTarget": {
                  "DnsName.$": "$.CreateDistributionResult.Distribution.DomainName",
                  "EvaluateTargetHealth": false,
                  "HostedZoneId": "Z2FDTNDATAQYW2"
                }
              }
            }
          ]
        }
      },
      "ResultPath": "$.AliasRecordCreationResult",
      "Next": "VerifyAliasRecord"
    },
    "VerifyAliasRecord": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:route53:getChange",
      "Parameters": {
        "Id.$": "$.AliasRecordCreationResult.ChangeInfo.Id"
      },
      "ResultPath": "$.AliasRecordVerificationResult",
      "Next": "CheckAliasRecordStatus"
    },
    "CheckAliasRecordStatus": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.AliasRecordVerificationResult.ChangeInfo.Status",
          "StringEquals": "INSYNC",
          "Next": "AliasRecordCreated"
        }
      ],
      "Default": "WaitForAliasRecord"
    },
    "WaitForAliasRecord": {
      "Type": "Wait",
      "Seconds": 30,
      "Next": "VerifyAliasRecord"
    },
  "AliasRecordCreated": {
  "Type": "Task",
  "Resource": "arn:aws:states:::aws-sdk:ses:sendEmail",
  "Parameters": {
    "Source.$": "$.SourceEmail",
    "Destination": {
      "ToAddresses.$": "$.DestinationEmail"
    },
    "Message": {
      "Subject": {
        "Data": "Alias Record Created Successfully!and cdn is up and running and it is accessible with the following Domain"
      },
      "Body": {
        "Text": {
          "Data.$": "$.DomainName"
        }
      }
    }
  },
  "End": true
  }
}
}
