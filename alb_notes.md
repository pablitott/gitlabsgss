[Create the application load balancer](https://hiveit.co.uk/techshop/terraform-aws-vpc-example/04-create-the-application-load-balancer/)
1. Create security group                                    aws_security_group
2. Create one ALB pointed to                                aws_alb
    1. One security group (above) sg_default
    2. many subnets subnet.*.id
3. Create one ALB_target_group                              aws_alb_target_group
    2. point to vpc
4. create 2 alb_listener                                    aws_alb_listener
    1. http listener - pointed to ALB.arn in point 2
    2. https listener - pointed to ALB.arn in point 2
5. Create an aws_route_53 pointed to                        aws_route53_record
    1. http listener ALB in point 2

[Create web server instances](https://hiveit.co.uk/techshop/terraform-aws-vpc-example/06-create-web-server-instances/)

6. Create the key pair                                      aws_key_pair
7. Create a new EC2 launch configuration.                   aws_launch_configuration
8. Create the auto scaling group                            aws_autoscaling_group
    1. Linked to aws_alb_target_group in point 3
9. Enable inbound traffic for the web server instances
   in our default security group         
   modify the security_group to 
   allow only allowed_cidr_blocks below



Variables
* Use in current script
    variable "allowed_cidr_blocks" {
    type = "list"
    }


