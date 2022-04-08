# output "alb_target_group_arn"{
#     value = aws_alb_target_group.high.arn
# }

# output "alb_target_group_arn"{
#     value = aws_alb_target_group.high.arn
# }

output "alb-endpoint" {
  value = aws_alb.alb.dns_name
}
