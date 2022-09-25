resource "aws_lb_target_group" "target_group" { 
    health_check {
        interval            = 10
        path                = "/" 
        protocol            ="HTTP" 
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2 
} 
    name          = "whiz-tg" 
    port          =  80
    protocol      = "HTTP" 
    target_type   = "instance" 
    vpc_id        = "${aws_vpc.demo_vpc.id}"
    depends_on = [aws_vpc.demo_vpc]  
}

#creating ALB 
resource "aws_lb" "application_lb" { 
    name          = "whiz-alb"
    internal      = false 
    ip_aip_address_type =  "ipv4" 
    load_balancer_type = "application" 
    security_group = [data.aws_security_group.allow_tls.id]  
    subnets = [data.aws_subnet_ids.Public_subnet.id] 

    tags = {
        Name = "whiz-alb"
    }
} 

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP" 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  } 
} 

resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web-server
  count            = length(aws_instance.web-server)
}
