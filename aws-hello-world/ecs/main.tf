resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_lb" "alb" {
  name               = "${var.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ecs_security_group]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.cluster_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200-499"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.cluster_name}"
  retention_in_days = 7

  # Prevent Terraform from failing if it already exists
  skip_destroy = true
}

resource "aws_ecs_task_definition" "task" {
  depends_on = [aws_cloudwatch_log_group.ecs_logs]
  family                   = var.cluster_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.image_url
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/hello-world-cluster"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_security_group]
    assign_public_ip = true
  }

load_balancer {
  target_group_arn = aws_lb_target_group.tg.arn
  container_name   = var.container_name
  container_port   = var.container_port
}


  depends_on = [
    aws_lb.alb,
    aws_lb_target_group.tg,
    aws_lb_listener.http,
    aws_cloudwatch_log_group.ecs_logs
  ]
}
