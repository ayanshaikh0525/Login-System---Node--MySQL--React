# cluster 

resource "aws_ecs_cluster" "main" {
  name = "login-app-cluster"
}



# Task Defination

resource "aws_ecs_task_definition" "backend_task" {
  family = "backend-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.backend_repo.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.address
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_DATABASE"
          value = var.db_name
        },
        {
          name  = "PORT"
          value = "5000"
        },
        {
          name = "DB_WAITFORCONNECTIONS"
          value = "true"
        },
        {
        name = "DB_CONNECTIONLIMIT"
        value = "10"
        },
        {
        name = "DB_QUEUELIMIT"
        value = "0"
        },
        {
        name = "DB_TABLENAME"
        value = var.db_tablename
        },
        {
        name = "JWT_SECRET"
        value = var.JWT_SECRET
        }
      ]

    }
  ])
}


# ECS Service

resource "aws_ecs_service" "backend_service" {
  name = "backend-service"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type = "FARGATE"
  desired_count = 2

  health_check_grace_period_seconds = 60

  depends_on = [
  aws_db_instance.mysql,
  aws_lb_listener.listener
  ]

  network_configuration {
    subnets = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "backend"
    container_port   = 5000
  }
}