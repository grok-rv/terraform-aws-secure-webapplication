#-----------------------module/a-loadbalancer/main.tf-------------------
#----------create an application load balancer---------------------
resource "aws_lb" "alb-frontend" {
  name = "aws-alb"
  internal = false
  security_groups = [ var.alb-sg ]
  subnets = var.pub-subnet 
  enable_cross_zone_load_balancing = true
  ip_address_type = var.ip_type
  tags = {
    Name = "alb-frontend"
  }
}

#------------------------creata a load balancer target group with health check settings------------
resource "aws_lb_target_group" "alb-frontend" {
  name = "alb-targetgroup"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc-id
  
  health_check {
    path                = "/"
    timeout             = "5"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "30"
  }

 }

#--------------create a http listenr for load balancer----------------------
resource "aws_lb_listener" "alb-frontend" {
  load_balancer_arn = aws_lb.alb-frontend.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-frontend.arn
  }
  
}

#-----------attach ec2 instances to the the application load balancer---------------------------------
resource "aws_lb_target_group_attachment" "alb-frontend" {
  count = 2
  target_group_arn = aws_lb_target_group.alb-frontend.arn
  target_id =  "${element(split(", ", join(", ", var.target-id)), count.index)}"
  port = 80
}
