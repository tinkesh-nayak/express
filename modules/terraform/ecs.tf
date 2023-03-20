
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "ecsTaskRole"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

data "aws_ecs_task_definition" "nodeapp" {
  task_definition = aws_ecs_task_definition.nodeapp.family

}

resource "aws_ecs_cluster" "main" {
  name = "nodejscluster"
}

resource "aws_ecs_task_definition" "nodeapp" {
  family                   = "mynodeapp"
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = <<TASK_DEFINITION
[
  {
    "essential": true,
    "image": "904940538083.dkr.ecr.ap-south-1.amazonaws.com/nodeapp-repo:latest",
    "name": "nodeapp",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "nodeapp" {
  name            = "node-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = data.aws_ecs_task_definition.nodeapp.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "nodeapp"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role.ecs_tasks_execution_role]
}