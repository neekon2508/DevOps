# S3

- S3 -> Buckets -> Create bucket
- Choose bucket -> Upload/Create folder

# Bucket Policy

- AWS Policy Generator: awspolicygen.s3.amazonaws.com/policygen.html

# S3 Websites

- Choose bucket -> Properties -> Static website -> Edit -> Enable + Index document

# S3 Versioning

- Choose bucket -> Properties -> Edit -> Bucket Versioning: Enable

# Liiecycle Rules

- Choose bucket -> Management -> Create lifecycle rule -> Lifecycle rule actions

# S3 Event Notification

- Choose bucket -> Properties -> Amazon EventBridge:Edit:On -> Create event notification
- AWS Policy Generator: awspolicygen.s3.amazonaws.com/policygen.html

# S3 Encryption

- When create bucket -> Default encryption
- Click file -> Server-side encryption settings: Edit

# S3 CORS

- Choose bucket -> Permissions -> CORS: Edit

```
[
  {
    "AllowedHeaders": [
        "Authorization"
    ],
    "AllowedMethods": [
        "GET"
    ],
    "AllowedOrigins": [
        "<origin>"
    ],
    "ExposeHeaders": [],
    "MaxAgeSeconds": 3000
  }
]
```
# S3 MFA Delete
- When create bucket -> Default encryption: Enable
- IAM -> Your Security Credentials -> MFA: Serial number 
Access key -> Create access key: access key + secret access key
```
# generate root access keys
aws configure --profile root-mfa-delete-demo

# enable mfa delete
aws s3api put-bucket-versioning --bucket <bucket> --versioning-configuration Status=Enabled,MFADelete=Enabled --mfa "arn-of-mfa-device mfa-code" --profile <profile>
# disable mfa delete
aws s3api put-bucket-versioning --bucket <bucket> --versioning-configuration Status=Enabled,MFADelete=Disabled --mfa "arn-of-mfa-device mfa-code" --profile <profile>
# delete the root credentials in IAM console
```
# S3 Access Logs
- Choose bucket -> Edit server access logging: Enable
# S3 Pre-signed URLs
- Choose object -> Object actions -> Share with a presigned URL