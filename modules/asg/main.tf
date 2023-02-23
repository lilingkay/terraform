#create launch configuration
resource "aws_launch_configuration" "create_launchconfig" {
  name                        = var.asg.launchconfig_name
  image_id                    = var.asg.launchconfig_ami_id
  instance_type               = var.asg.launchconfig_instance_type
  iam_instance_profile        = var.asg.launchconfig_iam_user
  key_name                    = var.asg.launchconfig_key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.create_websg.id]
  user_data                   = file("./modules/asg_module/userdata.tpl")
}

#create auto scaling group
resource "aws_autoscaling_group" "create_asg" {
  name                      = var.asg.asg_name
  max_size                  = var.asg.asg_max_size
  min_size                  = var.asg.asg_min_size
  health_check_grace_period = var.asg.asg_health_check_grace_period
  health_check_type         = var.asg.asg_health_check_type
  desired_capacity          = var.asg.asg_desired_capacity 
  force_delete              = true
  target_group_arns         = [var.target_group_arns]
  launch_configuration      = aws_launch_configuration.create_launchconfig.name
  vpc_zone_identifier       = var.all_private_subnet

  tag {
    key                 = "Name"
    value               = var.asg.asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "GBL_CLASS_0"
    value               = "SERVICE"
    propagate_at_launch = true
  }
  tag {
    key                 = "GBL_CLASS_1"
    value               = "TEST"
    propagate_at_launch = true
  }
}
