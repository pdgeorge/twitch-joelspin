provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ffmpeg_instance" {
  ami           = "ami-0fa1ca9559f1892ec"
  instance_type = "t3.small"
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = ["allow-ssh", "allow-s3", "allow-twitch"]
  iam_instance_profile   = "EC2-admin"
  user_data              = file("./install_ffmpeg.sh")

  tags = {
    Name = "JoelSpinVT"
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair" # Specify a name for your key pair
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public key file
}

# Security Group for SSH
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["180.150.36.214/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for S3 Access
resource "aws_security_group" "allow-s3" {
  name        = "allow-s3"
  description = "Allow access to S3 bucket"

  ingress {
    from_port   = 80  # Assuming your tool uses HTTP to access S3
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443  # Assuming your tool uses HTTPS to access S3
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Twitch Streaming
resource "aws_security_group" "allow-twitch" {
  name        = "allow-twitch"
  description = "Allow streaming to Twitch"

  ingress {
    from_port   = 1935
    to_port     = 1935
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2088
    to_port     = 2088
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_ip" {
  value = aws_instance.ffmpeg_instance.public_ip
}