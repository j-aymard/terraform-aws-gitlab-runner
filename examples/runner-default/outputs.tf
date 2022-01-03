output "runner_sg_id" {
  description = "ID of the security group attached to the docker machine runners."
  value       = module.runner.runner_sg_id
}

output "runner_role_name" {
  description = "ID of the security group attached to the docker machine runners."
  value       = module.runner.runner_role_name
}

output "runner_efs_ip" {
  description = "ID of the security group attached to the docker machine runners."
  value       = module.efs.ip
}
output "vpn_gateway_id" {
  description = "ID of the security group attached to the docker machine runners."
  value       = module.vpc.vgw_id
}

output "vpn_private_route_table_ids" {
  description = "ID of the security group attached to the docker machine runners."
  value       = module.vpc.private_route_table_ids
}


