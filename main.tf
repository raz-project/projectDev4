terraform {
  backend "s3" {
    bucket = "tf-state-s3-buc"
    key    = "state/dev_ops/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}

module "tf-static" {
  source      = "./modules/tf-static-web"
  bucket_name = "new-static-123"

}


