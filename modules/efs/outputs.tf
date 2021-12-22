output "ip" {
  description = "ip of the efs"
  value       = data.aws_efs_mount_target.efs_by_id.ip_address
}

output "id" {
  description = "id of the efs"
  value       = aws_efs_file_system.efs.id
}
