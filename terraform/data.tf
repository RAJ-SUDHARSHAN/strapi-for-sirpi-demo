# Get available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
