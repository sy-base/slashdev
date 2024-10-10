provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Ubuntu
}

data "aws_route53_zone" "slashdev-org" {
  name = "slashdev.org."
}

resource "aws_instance" "origin-server" {
  ami           = data.aws_ami.image.id
  instance_type = "t3a.small"
  key_name      = "bacon-id_rsa"
  vpc_security_group_ids = [ "sg-097c47b767eae23ba", "sg-af64efe7", "sg-2730916e" ]
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
      encrypted = true
  }
  user_data = file("${path.module}/templates/user-data.tftpl")

  tags = {
    Name = "slashdev.org-origin"
  }
}

resource "aws_route53_record" "origin-dns" {
  zone_id = data.aws_route53_zone.slashdev-org.zone_id
  name    = "origin.slashdev.org."
  type    = "A"
  ttl     = "300"
  records = [ aws_instance.origin-server.public_ip ]
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "slashdev.org-artifacts"
  acl    = "private"
  versioning {
    enabled = false
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = "7"
    enabled = true
    expiration {
      days = 0
      expired_object_delete_marker = false
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_distribution" "slashdev_distribution" {
  origin {
    domain_name = "origin.slashdev.org"
    origin_id   = "slashdevOrigin"

    custom_origin_config {
      http_port = 9000
      https_port = 9443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "slashdev.org"
  default_root_object = "index.html"

  aliases = ["www.slashdev.org", "dev.slashdev.org", "slashdev.org"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "slashdevOrigin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:675169025934:certificate/eecc4e60-096c-4d71-8b1c-bc0f896ac764"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

resource "aws_route53_record" "slashdev-dns" {
  zone_id = data.aws_route53_zone.slashdev-org.zone_id
  name    = "slashdev.org."
  type    = "A"
  
  alias {
    name    = aws_cloudfront_distribution.slashdev_distribution.domain_name
    zone_id = aws_cloudfront_distribution.slashdev_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
