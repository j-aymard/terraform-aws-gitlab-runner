################################################################################
### Agent's instance launch template definition
################################################################################

locals {
  template_user_data = templatefile("../../template/user-data-efs-mount.tpl",
    {      
      efs_ip = var.efs_ip
  })
}

resource "aws_launch_template" "agent_instance" {

  name = "agent_launch_template"
  image_id               = var.ami_id
  
  user_data              = base64encode(local.template_user_data)
  instance_type          = "t3.micro"
  update_default_version = true
  ebs_optimized          = false
  key_name               = "CICD"
  monitoring {
    enabled = false
  }
  /*dynamic "instance_market_options" {
    for_each = var.runner_instance_spot_price == null || var.runner_instance_spot_price == "" ? [] : ["spot"]
    content {
      market_type = instance_market_options.value
      spot_options {
        max_price = var.runner_instance_spot_price == "on-demand-price" ? "" : var.runner_instance_spot_price
      }
    }
  }*/
  iam_instance_profile {
    name = var.iam_role//aws_iam_instance_profile.instance.name
  }
  /*dynamic "block_device_mappings" {
    for_each = [var.runner_root_block_device]
    content {
      device_name = lookup(block_device_mappings.value, "device_name", "/dev/xvda")
      ebs {
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", true)
        volume_type           = lookup(block_device_mappings.value, "volume_type", "gp3")
        volume_size           = lookup(block_device_mappings.value, "volume_size", 8)
        encrypted             = lookup(block_device_mappings.value, "encrypted", true)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        throughput            = lookup(block_device_mappings.value, "throughput", null)
        kms_key_id            = lookup(block_device_mappings.value, "`kms_key_id`", null)
      }
    }
  }*/
  network_interfaces {
    security_groups             = var.security_group_ids//concat([aws_security_group.runner.id], var.extra_security_group_ids_runner_agent)
    subnet_id = var.subnet_id
    associate_public_ip_address = true
  }
  /*tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
  dynamic "tag_specifications" {
    for_each = var.runner_instance_spot_price == null || var.runner_instance_spot_price == "" ? [] : ["spot"]
    content {
      resource_type = "spot-instances-request"
      tags          = local.tags
    }
  }*/

  //tags = local.tags

  /*metadata_options {
    http_endpoint = var.runner_instance_metadata_options_http_endpoint
    http_tokens   = var.runner_instance_metadata_options_http_tokens
  }*/

  lifecycle {
    create_before_destroy = true
  }
}