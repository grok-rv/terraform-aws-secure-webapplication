#----------------------------module/storage/main.tf---------------------

resource "random_id" "bucket_id" {
  byte_length = 2
}
#----------------------create a s3 bucket----------------------------------
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.projectname}-${random_id.bucket_id.dec}"
  acl = "private"
  force_destroy = true
  tags = {
    Name = "tfs_bucket"
  }
}

