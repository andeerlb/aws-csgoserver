resource "aws_autoscaling_group" "cs2" {
  name               = local.name_with_prefix
  availability_zones = var.azs
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  tag {
    key                 = "Terraform"
    value               = "yes"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.cs2.id
    version = aws_launch_template.cs2.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}