data "template_file" "file_user_data" {
  template = "${file("${path.module}/files/data.sh.tpl")}"

  vars = {
    SERVER_NAME = var.server_name
    RCON_PASSWD = var.rcon_passwd
  }
}

resource "aws_launch_template" "csgo" {
    name = "csgo"

    disable_api_termination = true
    ebs_optimized = false
    image_id = var.image_id
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t2.micro"
    user_data = base64encode(data.template_file.file_user_data.rendered) 

    key_name = var.ssh_key_pair

    block_device_mappings {
        device_name = "/dev/xvda"

        ebs {
            volume_size = 60
        }
    }

    monitoring {
        enabled = true
    }

    network_interfaces {
        associate_public_ip_address = true
        subnet_id = module.vpc_csgo.public_subnet_ids[0]
        security_groups = [aws_security_group.csgo.id]
    }

    tag_specifications {
        resource_type = "instance"
        tags = merge({
            Name = "csgoserver"
        }, var.default_tags)
    }
}