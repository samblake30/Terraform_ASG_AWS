data "aws_ami" "terraform_ami" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["${var.ami}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

/*##########################################################
THIS IS AWS LAUNCH CONFIGURATION
##########################################################*/
resource "aws_launch_configuration" "Lconfig" {
  name_prefix     = "agent-lc"
  image_id        = data.aws_ami.terraform_ami.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.Key_Pair.key_name
  security_groups = [aws_security_group.My_VPC_Security_Group.id]
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_size           = var.size
    volume_type           = "standard"
    delete_on_termination = var.dot
  }
  user_data = <<-EOF
            #!/bin/bash
            sudo yum install httpd wget -y 
            sudo echo Hello from $HOSTNAME !!! >/var/www/html/index.html
            sudo systemctl start httpd
            mkfs.xfs /dev/xvdc && mount /dev/xvdc /mnt/
            rsync -av /var/log/ /mnt/ &&  rm -rf /var/log/*
            umount /mnt/ && echo `blkid | grep /dev/xvdc | awk '{print $2 } '` /var/log/  xfs defaults 0 0 >>/etc/fstab && mount -a
            EOF

  lifecycle {
    create_before_destroy = true
  }

}

/*##########################################################
THIS IS AUTOSCALING GROUP
############################################################*/
resource "aws_autoscaling_group" "asg" {
  name_prefix          = "asg"
  max_size             = var.max_instance
  min_size             = var.min_instance
  launch_configuration = aws_launch_configuration.Lconfig.name
  vpc_zone_identifier  = [aws_subnet.Private_Subnet.id]
  #health_check_type         = "ELB"
  #health_check_grace_period = 300
  load_balancers = [aws_elb.elb.name]

  tag {
    key                 = "Name"
    value               = "Terraform-asg"
    propagate_at_launch = true
  }
}

/*##########################################################
THIS IS THE AUTOSCALING POLICY
###########################################################*/
resource "aws_autoscaling_policy" "MyUPpolicy" {
  name                   = "webserver-policy_UP"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "MyDOWNpolicy" {
  name                   = "webserver-policy_DOWN"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown
  scaling_adjustment     = -1
}


resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = var.up_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "CPU Utilization is high on EC2 Webservers"
  alarm_actions     = [aws_autoscaling_policy.MyUPpolicy.arn]

}


resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name          = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = "Average"
  threshold           = var.down_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "CPU Utilization is under control on EC2 Webservers"
  alarm_actions     = [aws_autoscaling_policy.MyDOWNpolicy.arn]

}


/*#########################################################
THIS IS THE ELB block_device
###########################################################*/
resource "aws_elb" "elb" {
  name_prefix     = "elb"
  security_groups = [aws_security_group.elbsg.id]
  subnets         = [aws_subnet.Public_Subnet.id]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
