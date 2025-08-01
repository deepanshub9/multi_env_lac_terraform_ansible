resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.env}-kuku-dp-bucket"

  tags = {
    Name        = "${var.env}-kuku-dp-bucket"
    Environment = var.env
  }
}