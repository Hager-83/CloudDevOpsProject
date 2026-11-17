terraform {
  backend "s3" {
    bucket       = "ivolve-tfstate-211017377170-us-east-1"
    key          = "ivolve/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}