

# route53.tf
data "aws_route53_zone" "my_zone" {
  name = "learning.theodoremayi.com"
}

resource "aws_route53_record" "my_record" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "learning.theodoremayi.com"
  type    = "A"

  alias {
    name                   = aws_lb.utc-lb.dns_name
    zone_id                = aws_lb.utc-lb.zone_id
    evaluate_target_health = true
  }
}