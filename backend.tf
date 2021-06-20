#Below block creates the statefile in the S3
terraform {
   backend "s3" {
   bucket = "mercury-prod-aravind"
   key = "mercury-s3.tfstate"
   region = "us-east-1"


   dynamodb_table = "mercury-lock-state"
   encrypt = true

 }
}

