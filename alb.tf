resource "aws_lb_target_group" "target_group" { 
    health_check {
        interval            = 10
        path                = "/" 
        protocol            ="HTTP" 
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2 
} 
    name          = "first-demo-tg" 
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
    ip_address_type =  "ipv4" 
    load_balancer_type = "application" 
    security_groups = ["${aws_security_group.allow_tls.id}"]  
    subnets = [aws_subnet.Public_subnetA.id, aws_subnet.Public_subnetB.id] 

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

resource "aws_lb_target_group_attachment" "web1_attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        =  aws_instance.web-server1[count.index].id
  count            = length(aws_instance.web-server1)
}
resource "aws_lb_target_group_attachment" "web2_attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        =  aws_instance.web-server2[count.index].id
  count            = length(aws_instance.web-server2)
}


/*module "network_load_balancer" {
  source  = "infrablocks/network-load-balancer/aws"
  version = "0.1.7"

  region = "eu-west-2"
  vpc_id = "vpc-fb7dc365"
  subnet_ids = "subnet-ae4533c4,subnet-443e6b12"

  component = "important-component"
  deployment_identifier = "production"

  domain_name = "example.com"
  public_zone_id = "Z1WA3EVJBXSQ2V"
  private_zone_id = "Z3CVA9QD5NHSW3"

  listeners = [
    {
      lb_port = 443
      lb_protocol = "HTTPS"
      instance_port = 443
      instance_protocol = "HTTPS"
      ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/default"
    },
    {
      lb_port = 6567
      lb_protocol = "TCP"
      instance_port = 6567
      instance_protocol = "TCP"
    }
  ]

  access_control = [
    {
      lb_port = 443
      instance_port = 443
      allow_cidr = "0.0.0.0/0"
    },
    {
      lb_port = 6567
      instance_port = 6567
      allow_cidr = "10.0.0.0/8"
    }
  ]

  egress_cidrs = "10.0.0.0/8"

  health_check_target = "HTTPS:443/ping"
  health_check_timeout = 10
  health_check_interval = 30
  health_check_unhealthy_threshold = 5
  health_check_healthy_threshold = 5

  enable_cross_zone_load_balancing = "yes"

  enable_connection_draining = "yes"
  connection_draining_timeout = 60

  idle_timeout = 60

  include_public_dns_record = "yes"
  include_private_dns_record = "yes"

  expose_to_public_internet = "yes"
}
*/
