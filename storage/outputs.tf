# ----------------------------------------------------------------------------------
# output terraform resources
# ------------------------------------------------------------------------------------------
output "terraformbucket" {
  value       = "${aws_s3_bucket.terraform-tfstate.arn}"
  description = "The terraform state bucket"
}

output "terraform-dynamodb" {
  value       = "${aws_dynamodb.terraform_locks.name}"
  description = "terraform dynamodb table for locking state"
}
