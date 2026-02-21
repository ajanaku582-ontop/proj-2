# resource "aws_cloudwatch_log_group" "vpc_logs" {
#   name = "/vpc/flowlogs"
# }

# resource "aws_iam_role" "flow_logs_role" {
#   name = "flow_logs_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "vpc-flow-logs.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy" "flow_logs_policy" {
#   role = aws_iam_role.flow_logs_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ]
#       Effect   = "Allow"
#       Resource = "*"
#     }]
#   })
# }

# resource "aws_flow_log" "main" {
#   vpc_id               = aws_vpc.main.id
#   traffic_type         = "ALL"
#   iam_role_arn         = aws_iam_role.flow_logs_role.arn
#   log_destination      = aws_cloudwatch_log_group.vpc_logs.arn
#   log_destination_type = "cloud-watch-logs"
# }