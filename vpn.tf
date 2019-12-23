# Creating AWS VPN gateway
resource "aws_vpn_gateway" "default" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${local.name}-vpn-gw"
  }
}

# Creating Customer Gateway
resource "aws_customer_gateway" "default" {
  count      = length(var.gateways)
  bgp_asn    = var.remote_bgp_asn
  ip_address = lookup(var.gateways[count.index], "address")
  type       = "ipsec.1"

  tags = {
    "Name" = lookup(var.gateways[count.index], "name")
  }
}

resource "aws_vpn_connection" "default" {
  count               = length(var.gateways)
  vpn_gateway_id      = aws_vpn_gateway.default.id
  customer_gateway_id = aws_customer_gateway.default[count.index].id
  type                = "ipsec.1"
  static_routes_only  = var.vpn_connection_static_routes_only

  tags = {
    "Name" = "VPN-${local.name}-${local.env_id}-${local.region_id}-CSR-${substr(lookup(var.gateways[count.index], "name"), length(lookup(var.gateways[count.index], "name")) - 2, 2)}"
  }
}

#Adding VGW to route table
resource "aws_vpn_gateway_route_propagation" "default" {
  vpn_gateway_id = aws_vpn_gateway.default.id
  route_table_id = aws_route_table.default.id
}

# Static IP VPN connection route
# create all of the static routes for all of the vpn connections
# if static routes = 3 and vpn connections = 2 then count = 6
resource "aws_vpn_connection_route" "default" {
  count                  = var.vpn_connection_static_routes_only ? length(var.gateways) * length(var.vpn_connection_static_routes_destinations) : 0
  vpn_connection_id      = aws_vpn_connection.default[count.index % length(var.gateways)].id
  destination_cidr_block = var.vpn_connection_static_routes_destinations[count.index % length(var.vpn_connection_static_routes_destinations)]
}
