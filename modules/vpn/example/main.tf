provider "aws" {
  region = var.aws_region
}

module "vpn_gateway" {
  source = "../"

  vpn_connection_static_routes_only         = false
  #vpn_connection_static_routes_destinations = ["10.100.0.1/32", "10.200.0.1/32"]

  vpn_gateway_id      = "vgw-0b9736fdd34403bf7"//module.vpc.vgw_id
  customer_gateway_id = aws_customer_gateway.main.id

  vpc_id                       = "vpc-06034ac8346a84ae9"
  vpc_subnet_route_table_ids   = ["rtb-0e04827d7a9957c5d"]
  vpc_subnet_route_table_count = length(["rtb-0e04827d7a9957c5d"])

  # tunnel inside cidr & preshared keys (optional)
  tunnel1_inside_cidr   = "169.254.33.88/30"
  tunnel1_preshared_key = "4ANwzYhduMP7fokJEh6JN3mTbsM10L7"
  tunnel1_phase1_dh_group_numbers = ["14"]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms = ["SHA2-256"]
  tunnel1_phase1_lifetime_seconds = 28800
  tunnel1_phase2_dh_group_numbers = ["14"]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms = ["SHA2-256"]
  tunnel1_phase2_lifetime_seconds = 3600
  tunnel1_ike_versions = ["ikev1"]
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = "141.94.102.157"
  type       = "ipsec.1"

  tags = {
    Name = "complete-vpn-gateway-with-static-routes"
  }
}
