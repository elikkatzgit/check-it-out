resource "aws_s3_bucket" "terraform_state" {
  bucket		  = "check-bucket"
  
  versioning {
    enabled = false
  }  
}

