# Creates CloudWatch Alarms for all VPN tunnels

resource "aws_cloudwatch_metric_alarm" "vpn_tunnel1_status" {
  count               = length(var.sns_topics) > 0 ? length(var.gateways) : 0
  alarm_name          = "${local.name}-vpn${count.index}-tunnel1-status"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TunnelState"
  namespace           = "AWS/VPN"
  period              = "60"
  dimensions = {
    TunnelIpAddress = aws_vpn_connection.default[count.index].tunnel1_vgw_inside_address
  }
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors the tunnel1 status of VPN${count.index}"
  insufficient_data_actions = []
  alarm_actions             = var.sns_topics
}

resource "aws_cloudwatch_metric_alarm" "vpn_tunnel2_status" {
  count               = length(var.sns_topics) > 0 ? length(var.gateways) : 0
  alarm_name          = "${local.name}-vpn${count.index}-tunnel2-status"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TunnelState"
  namespace           = "AWS/VPN"
  period              = "60"
  dimensions = {
    TunnelIpAddress = aws_vpn_connection.default[count.index].tunnel2_vgw_inside_address
  }
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors the tunnel2 status of VPN${count.index}"
  insufficient_data_actions = []
  alarm_actions             = var.sns_topics
}