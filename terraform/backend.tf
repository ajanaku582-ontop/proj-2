terraform {
  backend "s3" {
    bucket         = "funmi-cicd-state-bucket"
    key            = "env/dev-proj-2/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }   
}
