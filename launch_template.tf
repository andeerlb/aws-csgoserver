resource "aws_launch_template" "csgo" {
    name = "csgo"

    disable_api_termination = true
    ebs_optimized = false
    image_id = "ami-087c17d1fe0178315"
    instance_initiated_shutdown_behavior = "terminate"
    instance_type = "t2.micro"
    user_data = filebase64("${path.module}/files/data.sh")

    key_name = var.ssh_key_pair

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