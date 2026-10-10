resource "aws_s3_bucket" "multi_cloud_16a" {
  bucket = "multi-cloud-16a"

  tags = {
    Name        = "multi-cloud-test"
    Environment = "dev"
    Project     = "multi-cloud-terraform"
  }
}