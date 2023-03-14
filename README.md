# Cat Frontend

This repo is home to any and all code related to cat frontend. It contains the application code as well the terraform files
to deploy this app securly to s3 by using s3 static website hosting and cloudfront.

# Architecture
![Alt text](./docs/frontend.webp?raw=true "Architecture")

# Prerequisites:
1. Terraform  ---> https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
2. AWS CLI ---> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# Exploring the Repo

This is a simple frontend application, let's explpre the files:
1. docs  ---> has the Architecture diagram
2. infra ---> cas the  terraform files to deploy the app to s3 
3. index.html,styles.css,script.js ---> the website files
4. error.jpg ---> An image to be displayed if no image can be retrieved from the backend

Please note brefore deploying application, some values must be exposed (environment variables).
In the next section we will see those variables and what they mean.

# Note about script.js file
Since this is a static website, we can't have environment variables, so make sure to change
the value of "BACKEND_URL" variable in 'script.js' to be the dns of the backend.

# Environment variables needed for the stack

| variable | description | example |
| --------------- | --------------- | --------------- |
| TF_VAR_REGION | The Region to create the bucket | eu-central-1 |
| TF_VAR_BUCKET_NAME | The name of the bucket that will host the website files | my-test-bucket |
<br/>

# Example of deployng the app

```bash
cat << EOT > values.sh
#! /bin/bash
export TF_VAR_REGION='eu-central-1'
export TF_VAR_BUCKET_NAME='test-redis-backend_test_static'
EOT
```

```bash
chmod u+x values.sh && . values.sh
```

```bash
cd infra
```

```bash
terraform init
```

```bash
terraform apply
```

```bash
# Uploading the static files to s3
cd ../
aws s3 cp ./index.html s3://BUCKET_NAME/index.html
aws s3 cp ./script.js s3://BUCKET_NAME/script.js
aws s3 cp ./styles.css s3://BUCKET_NAME/styles.css
aws s3 cp ./error.jpg s3://BUCKET_NAME/error.jpg
```

### If you want to destroy the infra (make sure to empty the bucket of static files first)

```bash
cd infra
terraform destroy
```