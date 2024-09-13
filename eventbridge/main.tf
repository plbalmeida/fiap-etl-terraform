# obtém a role existente fiap-etl-role
data "aws_iam_role" "fiap_etl_role" {
  name = "fiap-etl-role"
}

# obtém a máquina de estado previamente criada
data "aws_sfn_state_machine" "fiap_etl_state_machine" {
  name = "fiap-etl"
}

# regra do EventBridge para disparar o Step Functions diariamente
resource "aws_cloudwatch_event_rule" "daily_fiap_etl" {
  name                = "fiap-etl-rule"
  description         = "Regra do EventBridge para executar a máquina de estado fiap-etl diariamente às 18:30 UTC"
  schedule_expression = "cron(30 18 * * ? *)"
}

# permissão para o EventBridge invocar o Step Functions
resource "aws_cloudwatch_event_target" "target_step_functions" {
  rule     = aws_cloudwatch_event_rule.daily_fiap_etl.name
  arn      = data.aws_sfn_state_machine.fiap_etl_state_machine.arn
  role_arn = data.aws_iam_role.fiap_etl_role.arn

  input = jsonencode({})
}
