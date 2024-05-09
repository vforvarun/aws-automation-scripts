import boto3

# Define the AWS client
ec2_client = boto3.client('ec2')
s3_client = boto3.client('s3')

# Test SCP 1: Deny Public S3 Bucket Access
def test_scp1():
    try:
        s3_client.create_bucket(Bucket='test-bucket', ACL='public-read')
        print("SCP 1 Test Failed: Able to create S3 bucket with public access")
    except Exception as e:
        print("SCP 1 Test Passed:", e)

# Test SCP 2: Restrict EC2 Instance Types
def test_scp2():
    try:
        response = ec2_client.run_instances(ImageId='ami-0ec0514235185af79', MinCount=1, MaxCount=1, InstanceType='t3.large')
        print("SCP 2 Test Failed: Able to launch instance with restricted instance type")
    except Exception as e:
        print("SCP 2 Test Passed:", e)

# Run the tests
def main():
    test_scp1()
    test_scp2()

if __name__ == "__main__":
    main()

