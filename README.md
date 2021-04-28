# DevOps Assignment

## How To Get This Working ?

I have automated literally everything. Simple terraform deploy will do 

1. Create deployment zip for lambda.
2. Deploy infrastructure to your AWS account.

Simple - Automate & Chill..!!

## Steps To Deploy Infrastucture
1. Change bucket name in if you get already exists error.
2. Change profile name & Region in `variables.tf`
3. Then Deploy Using Commands below :

```
terraform init
terraform plan
terraform apply -auto-approve
```

## Bonus 
1. Lambda zip codes on the fly and upload while creating infrastructure.

