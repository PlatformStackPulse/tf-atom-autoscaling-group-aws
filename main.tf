resource "aws_autoscaling_group" "this" {
  count = module.this.enabled ? 1 : 0

  name                      = module.this.id
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = var.target_group_arns
  force_delete              = var.force_delete

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  dynamic "instance_refresh" {
    for_each = var.instance_refresh_enabled ? [1] : []
    content {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = var.min_healthy_percentage
      }
    }
  }

  dynamic "tag" {
    for_each = merge(module.this.tags, { Name = module.this.id })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
