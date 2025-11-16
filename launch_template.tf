data "template_file" "file_user_data" {
  for_each = var.servers
  
  template = file("${path.module}/files/data.sh.tpl")

  vars = {
    SERVER_NAME   = each.value.server_name
    RCON_PASSWD   = each.value.rcon_passwd
    GSLT_TOKEN    = each.value.gslt_token
    SERVER_PASSWD = each.value.server_passwd
  }
}

resource "aws_launch_template" "cs2" {
  for_each = var.servers
  
  name = "cs2server_${each.value.server_name}"

  disable_api_termination              = true
  ebs_optimized                        = true
  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = each.value.instance_type
  user_data                            = base64encode(data.template_file.file_user_data[each.key].rendered)

  key_name = each.value.ssh_key_pair

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 80
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 125
      delete_on_termination = true
    }
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = module.vpc_cs2.public_subnet_ids[0]
    security_groups             = [aws_security_group.cs2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge({
      Name       = "cs2server_${each.value.server_name}"
      ServerKey  = each.key
      ServerName = each.value.server_name
    }, var.default_tags)
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.cs2server[each.key].name
  }

  tags = merge({
    Name       = "cs2server_${each.value.server_name}"
    ServerKey  = each.key
    ServerName = each.value.server_name
  }, var.default_tags)
}