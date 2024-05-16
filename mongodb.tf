resource "aws_subnet" "mongodb_subnet" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.4.0/24" 
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb-security-group"
  description = "Allow MongoDB access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"] 
  }

  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting this for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mongodb" {
  ami             = "ami-016ae044d99300b1e" # Ubuntu AMI for MongoDB
  instance_type   = "t3.small" 
  subnet_id       = module.vpc.public_subnets[0] # aws_subnet.mongodb_subnet.id
  key_name        = "yatin-key-pair"
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]
  associate_public_ip_address = true
  iam_instance_profile   = aws_iam_instance_profile.s3-write-profile.name
  user_data = data.cloudinit_config.mongo-files.rendered
}

# cloud-init config for user-data script and backup script
data "cloudinit_config" "mongo-files" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "cloud.conf"
    content = yamlencode(
      {
        "write_files" : [
          {
            "path" : "/home/bitnami/mongodb-backup.sh",
            "content" : file("mongodb-backup.sh"),
          }
        ],
      }
    )
  }
}