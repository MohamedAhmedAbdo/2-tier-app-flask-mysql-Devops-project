#flask app ECR
resource "aws_ecr_repository" "flask_ecr" {
  name                 = "flask_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#mysql ECR
resource "aws_ecr_repository" "sql_ecr" {
  name                 = "sql_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}



