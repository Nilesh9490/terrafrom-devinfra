# Create ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

# Create Security Group for ECS instances
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add any additional inbound rules as needed

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM Role for ECS instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach IAM Policy to ECS Instance Role
resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs_instance_role.name
}

# Launch Configuration for ECS Instances
resource "aws_launch_configuration" "ecs_launch_config" {
  name          = "ecs-launch-config"
  image_id      = "ami-007ec828a062d87a5"  # Update with your desired AMI
  instance_type = "t2.micro"                # Update with your desired instance type

  security_groups = [aws_security_group.ecs_sg.id]

  # Configure userdata for ECS agent registration
  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.my_cluster.name} >> /etc/ecs/ecs.config
              EOF

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"

  role = aws_iam_role.ecs_instance_role.name
}

# Auto Scaling Group for ECS Instances
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                      = "ecs-autoscaling-group"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = ["var.private_subnets"]  # Update with your subnet ID
  launch_configuration      = aws_launch_configuration.ecs_launch_config.name
  health_check_type         = "EC2"
  termination_policies      = ["OldestInstance"]
  tag {
    key                 = "Name"
    value               = "ECSInstance"
    propagate_at_launch = true
  }
}

# Create IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach IAM Policies to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Create IAM Policy for ECS Task
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "ecs-task-policy"
  description = "IAM policy for ECS task"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach IAM Policy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Create Task Definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-definition"
  container_definitions    = <<EOF
[
  {
    "name": "my-container",
    "image": "nginx:latest",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
    network_mode = "awsvpc"
}

# Create ECS Service
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets         = var.*.private_subnets  
    security_groups = [aws_security_group.ecs_sg.id]
  }
}
