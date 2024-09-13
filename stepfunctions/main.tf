# referência para a role IAM
data "aws_iam_role" "fiap_etl_role" {
  name = "fiap-etl-role"
}

# definição da máquina de estado do Step Functions
resource "aws_sfn_state_machine" "fiap_etl" {
  name     = "fiap-etl"
  role_arn = data.aws_iam_role.fiap_etl_role.arn

  definition = jsonencode({
    "Comment" : "Orquestração dos jobs de ETL usando Step Functions",
    "StartAt" : "ExtractJob",
    "States" : {
      "ExtractJob" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::glue:startJobRun.sync",
        "Parameters" : {
          "JobName" : "extract"
        },
        "Catch" : [{
          "ErrorEquals" : ["States.ALL"],
          "Next" : "FailState"
        }],
        "Next" : "TransformJob"
      },
      "TransformJob" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::glue:startJobRun.sync",
        "Parameters" : {
          "JobName" : "transform"
        },
        "Catch" : [{
          "ErrorEquals" : ["States.ALL"],
          "Next" : "FailState"
        }],
        "Next" : "LoadJob"
      },
      "LoadJob" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::glue:startJobRun.sync",
        "Parameters" : {
          "JobName" : "load"
        },
        "Catch" : [{
          "ErrorEquals" : ["States.ALL"],
          "Next" : "FailState"
        }],
        "End" : true
      },
      "FailState" : {
        "Type" : "Fail",
        "Error" : "JobFailed",
        "Cause" : "A execução do job falhou."
      }
    }
  })
}
