<h1 align="center">
   <a href="#">Infrastructure as Code Template</a><br />
   <small>(Terraform)</small>
</h1>


<p align="center">
 <a href="#about">About</a> •
 <a href="#how-it-works">How it works</a> •
 <a href="#tech-stack">Tech Stack</a>


## About

The project utilizes the AWS VPC Solution Pattern to implement its architecture. This pattern provides a secure and isolated network environment for the project's resources. It allows for the segmentation of resources into different subnets, enabling better control over network traffic and access.

![VPC Solution Architecture](./vpc-solution.png)


In addition to the AWS VPC Solution Pattern, the project follows a serverless approach. This means that instead of managing and provisioning servers, the project leverages AWS services such as AWS Lambda, AWS API Gateway, and AWS DynamoDB to build scalable and cost-effective solutions. By adopting a serverless architecture, the project benefits from automatic scaling, reduced operational overhead, and pay-per-use pricing model.


![Architecture](./obsidian.jpg)

## How it works

1. Install Terraform: https://developer.hashicorp.com/terraform/install
2. Install aws cli: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
3. Docker: https://docs.docker.com/engine/install/
4. Configure aws profile: `aws configure --profile=YOUR_PROFILE_NAME`
5. Clone repository: `git clone url-repository`
6. Enter in `Arklok.ArkiaIaC` folder
7. Inside the location of repository create file `ENVIRONMENT_NAME.s3.tfbackend` with example content:
    ```
    bucket = "bucket-name-to-store-tfstate-tf-state"
    key = "ENVIRONMENT_NAME.tfstate"
    region = "us-east-1"
    profile = "YOUR_PROFILE_NAME" #same of the step 3
    ```
8. Run the following command to create the bucket with versioning activated:
    ```
    aws s3api create-bucket --bucket bucket-name-to-store-tfstate-tf-state --profile YOUR_PROFILE_NAME

    aws s3api put-bucket-versioning --bucket bucket-name-to-store-tfstate-tf-state --versioning-configuration --profile YOUR_PROFILE_NAME
    ```
    
9. Inside the location of repository create file `ENVIRONMENT_NAME.tfvars` with example content:
    ```
    environment = "ENVIRONMENT_NAME"
    region = "us-east-1"
    dns_zone_name = "your-domain"
    initial_db_name = "INITIAL_DB_NAME"
    master_username = "MASTER_DB_USERNAME"
    master_password = "MASTER_DB_PASSWORD"
    ```
10. run: `tofu init -backend-config=./ENVIRONMENT_NAME.s3.tfbackend`
11. run: `tofu apply -var-file ENVIRONMENT_NAME.tfvars`
## Tech Stack
- [Terraform](https://www.terraform.io/)
- [AWS Cli](https://aws.amazon.com/pt/cli/)

---