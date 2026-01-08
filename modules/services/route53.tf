# resource "aws_route53_zone" "zone" {
#   name = "stg.obsidian.internal"
#   vpc {
#     vpc_id = var.vpc_id
#   }
#   tags = merge(local.tags, { Name = var.environment })
# }

# resource "aws_route53_record" "api-a" {
#   zone_id = aws_route53_zone.zone.zone_id
#   name    = "obsidian-api"
#   type    = "A"
#   ttl     = "300"
#   records = aws_lb.apiService_alb.dns_name
# }

# resource "aws_route53_record" "datapolling-a" {
#   zone_id = aws_route53_zone.zone.zone_id
#   name    = "datapolling"
#   type    = "A"
#   ttl     = "300"
#   records = aws_lb.datapollingService_alb.dns_name
# }

