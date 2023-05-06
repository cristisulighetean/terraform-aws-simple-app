# Simple web app deployment to AWS using Terraform

This Terraform module deploys a simple web application on AWS using EC2 instances and an Application Load Balancer (ALB). The module is designed to be flexible and easy to use, enabling you to quickly set up a basic web application infrastructure.

## Table of Contents

- Features
- Requirements
- Usage
- Future Improvements
- Gotchas

## Features

- Creates EC2 instances for running the web application
- Sets up an Application Load Balancer to distribute incoming traffic to the instances
- Configures security groups for the instances and ALB
- Supports customizing the number of instances, instance type, and other parameters
- Supports multiple environments using Terraform workspaces

## Requirements

- Terraform v0.13 or higher
- AWS provider v3.0 or higher

## Usage

Clone the repository:

```bash
git clone https://github.com/cristisulighetean/terraform-aws-simple-app.git
```

### Create the dev & prod workspaces

```bash
terraform workspace new dev
terraform workspace new prod

# List available workspaces
terraform workspace list

# Switch to an existing workspace
terraform workspace select prod
``` 

### Deploy the remote backend

1. Provide the backend configuration variables in the backend-config folder
   1. Create a new folder in the backend-infrastructure folder called `backend-config`
   2. Create two files in the backend-config folder called `dev.tfvars` and `prod.tfvars`
   3. Fill out the `dev.tfvars` and `prod.tfvars` files with the following variables:

      ```tf
      bucket = bucket_name
      key    = key_name for the terraform.tfstate file
      region = region_name
      dynamodb_table = dynamodb_table_name for the terraform state locking
      ```

2. Provide the necessary variables for the `backend-infrastructure` project
   1. Use the `dev.tfvars` and `prod.tfvars` files from the `backend-config` folder, they will be used in the main.tf of the backend-infrastructure project

3. Create the remote backend infrastructure

   1. First, we have to run the project with the local backend to then switch to the remote backend. Make sure that the remote backend is commented out.

      ```hcl
      # backend "s3" {
      #     encrypt        = true
      # }
      ```

    2. Deploy the necessary resources.

         ```bash
         terraform workspace select dev
         terraform init
         terraform apply -var-file=backend-config/dev.tfvars
         ```

    3. Uncomment the remote backend configuration from step 1 and initialize the remote backend.

         ```bash
         terraform init -backend-config=backend-config/dev.tfvars
         ```

    4. Repeat the steps above for the prod environment by replacing dev with prod.

### Deploy the web-app

1. Create the necessary files for the  variables in the `web-app` folder
   1. Use the `backend-config` folder for the remote backend configuration. It should contain `dev.tfvars` and `prod.tfvars` files. All the variables have to match to the previously created remote backend besides the `key`

      ```tf
      bucket = bucket_name
      key    = key_name for the terraform.tfstate file
      region = region_name
      dynamodb_table = dynamodb_table_name for the terraform state locking
      ```

    2. Create a new folder in the `web-app` folder called `variables`. Inside the `variables` folder, create two files named `dev.tfvars` and `prod.tfvars`. These files will be used for the variables needed for the root project. Provide the following variables in the respective `dev.tfvars` and `prod.tfvars` files

         ```tf
         region         = region_name

         web_app_config = {
            bucket_prefix   = bucket_prefix_name
            domain          = domain_name
            instance_type   = instance_type_name
            environment     = environment_name

         }

         db_credentials = {
            name = db_name
            user = db_user
            password = db_password
            instance_type   = instance_type_name
         }
         ```

2. Deploy the web-app
   1. Make sure you are connected to the AWS account via the CLI
   2. Deploy the project for the dev environment

   ```bash
   terraform workspace select dev
   terraform init -backend-config=backend-config/dev.tfvars
   terraform plan -var-file=variables/dev.tfvars
   terraform apply -var-file=variables/dev.tfvars

   ```

   3. Deploy the project for the prod environment
   
   ```bash
   terraform workspace select prod
   terraform init -backend-config=backend-config/prod.tfvars
   terraform plan -var-file=variables/prod.tfvars
   terraform apply -var-file=variables/prod.tfvars

   ```

3. After deployment, update the name servers for your domain at your domain registrar to delegate DNS management to Route 53. To do this, go to your domain registrar's control panel, find the settings for managing DNS or name servers, and replace the existing name servers with the name servers provided by Route 53 in the NS record of your hosted zone.

### Destroy the projects

Perform terraform destroy on both projects folders starting with the `web-app`. Make sure to pass the appropriate `-var-file` flag for the environment you're destroying. Check the AWS Management Console to ensure that everything was destroyed.



## Future Improvements

- Add support for Auto Scaling Groups to automatically scale the number of instances based on demand.
- Integrate with additional AWS services, such as RDS for database support or S3 for static asset storage.
- Improve the module's flexibility by allowing users to configure more parameters, such as custom security group rules.
- Enhance the health check settings of the target group for better instance health monitoring.
- Add support for HTTPS and SSL/TLS certificates for secure connections.

## Gotchas

- Make sure to use a unique name for the security groups and load balancers, as duplicate names will cause errors.
- Ensure that the specified AMI ID is valid and available in the selected region.
- Make sure you are in the correct AWS region when looking up the deployed instances.
- When destroying the infrastructure, pass the appropriate -var-file flag for the environment being destroyed.
- Always ensure that you have selected the correct Terraform workspace before deploying or destroying resources.
