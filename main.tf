terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.56"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region  = "us-west-2" # Change this to your preferred region
  profile = "default"   # Use your AWS CLI profile
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ecs-vpc"
  }
}

# Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ecs-internet-gateway"
  }
}

# Fetch available availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}


# Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "ecs-public-subnet"
  }
}

# Create a Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "ecs-public-route-table"
  }
}

# Associate the Route Table with the Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Security Group for ECS Tasks
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs-sg-"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-security-group"
  }
}

# Create an ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
  name = "free-tier-cluster"
}

# Create an IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect    = "Allow",
        Principal = { Service: ["ecs-tasks.amazonaws.com"] },
        Action    = ["sts:AssumeRole"]
      }
    ]
  })
}

# Attach the AmazonECSTaskExecutionRolePolicy to the Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an ECS Task Definition (Fargate)
resource "aws_ecs_task_definition" "app_task" {
  family                   = "free-tier-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256" # Minimum for Fargate (0.25 vCPU)
  memory                   = "512" # Minimum for Fargate (512 MB)
  
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      : "nginx-container",
      image     : "nginx:latest", # Replace with your container image if needed.
      cpu       : 256,
      memory    : 512,
      essential : true,
      portMappings: [
        {
          containerPort : 80,
          hostPort      : 80,
          protocol      : "tcp"
        }
      ]
    }
  ])
}

# Create an ECS Service to Run the Task in the Cluster
resource "aws_ecs_service" "app_service" {
  name            = "free-tier-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public_subnet.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip= true 
  }

  desired_count   = 1 # Free Tier allows minimal resources

}



