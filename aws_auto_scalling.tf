resource "aws_autoscaling_group" "csgo" {
  name = "csgoserver"
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
    id = aws_launch_template.csgo.id
    version = aws_launch_template.csgo.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}