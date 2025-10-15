terraform {
  backend "s3" {
    bucket         = "sirpi-terraform-states"
    key            = "states/sess_fc962d732d90/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "sirpi-terraform-locks"
    encrypt        = true
  }
}

# State locking prevents concurrent terraform applies
# Versioning allows rollback to previous states
# Encryption protects sensitive data in state
