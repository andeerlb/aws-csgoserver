resource "aws_autoscaling_group" "cs2" {
  for_each = var.servers
  
  name               = "cs2server_${each.value.server_name}"
  availability_zones = var.azs
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  tag {
    key                 = "Name"
    value               = "cs2server_${each.value.server_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "ServerKey"
    value               = each.key
    propagate_at_launch = true
  }

  tag {
    key                 = "ServerName"
    value               = each.value.server_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "yes"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.cs2[each.key].id
    version = aws_launch_template.cs2[each.key].latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}