resource "aws_secretsmanager_secret" "token-secretmanager" {
  name = "token"
}

resource "aws_secretsmanager_secret_version" "auth_token_version" {
  secret_id     = aws_secretsmanager_secret.token-secretmanager.id
  secret_string = "$DJISA<$#45ex3RtYr"
}
