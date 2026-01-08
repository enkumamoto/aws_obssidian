# resource "aws_secretsmanager_secret" "SMTPClient" {
#   name        = "dev/obsidian/obsidian__SMTP__Client_${var.environment}"
#   description = "SMTP Client Configuration"

#   tags = {
#     Environment = var.environment
#   }
# }

# resource "aws_secretsmanager_secret_version" "SMTPClient" {
#   secret_id = aws_secretsmanager_secret.SMTPClient.id
#   secret_string = jsonencode({
#     Server    = "smtp.gmail.com"
#     Port      = "587"
#     UserName  = "obsidiandev123@gmail.com"
#     Password  = "ztmd pzzc nlxr ghsx"
#     EnableSSL = "false"
#   })

#   depends_on = [aws_secretsmanager_secret.SMTPClient]
# }
