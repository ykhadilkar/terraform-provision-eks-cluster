resource "aws_s3_bucket" "mongodb-backup" {
  bucket = "yatin-mongodb-backup" 
  tags = {
    Name = "yatin-mongodb-backup"
  }
}


resource "aws_s3_bucket_public_access_block" "mongodb-backup-public-access" {
  bucket = aws_s3_bucket.mongodb-backup.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "world-read-policy" {
  bucket = aws_s3_bucket.mongodb-backup.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.mongodb-backup.id}",
          "arn:aws:s3:::${aws_s3_bucket.mongodb-backup.id}/*"
        ]
      }
    ]
  })
}
