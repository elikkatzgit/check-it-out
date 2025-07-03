# microservice1 instance
resource "aws_instance" "microservice_1" {
  ami           = "ami-0c02fb55956c7d316"  
  instance_type = "t2.micro"
  security_groups = [aws_security_group.microservice1_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 16      
    volume_type = "gp3"
  }
  depends_on = [aws_security_group.microservice1_sg,aws_iam_instance_profile.ec2_profile]
}

# Security group allowing HTTP traffic to instance
resource "aws_security_group" "microservice1_sg" {
  name        = "microservice1_sg"
  description = "Allow HTTP inbound"

  ingress {
    description = "HTTP from ELB"
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
}

#Classic ELB resource in front of the instance
resource "aws_elb" "check_elb" {
  name               = "check-elb"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = [aws_instance.microservice_1.id]
}
