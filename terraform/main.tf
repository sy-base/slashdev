provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "name"
    values = [ var.ec2_image_name ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [ var.ec2_image_owner ]
}

data "aws_route53_zone" "slashdev-org" {
  name = "slashdev.org."
}

resource "aws_instance" "origin-server" {
  ami           = data.aws_ami.image.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_instance_sshkey
  vpc_security_group_ids = var.ec2_instance_securitygroup_ids
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
      encrypted = true
  }
  user_data = templatefile("${path.module}/templates/user-data.tftpl",
    {
      deployment_branch = var.deployment_branch
    }
  )
  user_data_replace_on_change = true

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

resource "aws_cloudfront_distribution" "slashdev_distribution" {
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name = "origin.slashdev.org"
    origin_id   = "slashdevOrigin"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }

    origin_shield {
      enabled              = true
      origin_shield_region = "us-east-1"
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
    min_ttl                = 300
    default_ttl            = 3600
    max_ttl                = 86400
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
