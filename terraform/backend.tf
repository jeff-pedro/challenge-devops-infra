terraform {
  backend "s3" {
    bucket = "terraform-states-aluraflix"
    key    = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}
