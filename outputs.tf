
output "runner_agent_role_arn" {
  description = "ARN of the role used for the ec2 instance for the GitLab runner agent."
  value       = aws_iam_role.instance.arn
}

output "runner_agent_role_name" {
  description = "Name of the role used for the ec2 instance for the GitLab runner agent."
  value       = aws_iam_role.instance.name
}

output "runner_role_arn" {
  description = "ARN of the role used for the docker machine runners."
  value       = aws_iam_role.docker_machine.arn
}

output "runner_role_name" {
  description = "Name of the role used for the docker machine runners."
  value       = aws_iam_role.docker_machine.name
}

output "runner_agent_sg_id" {
  description = "ID of the security group attached to the GitLab runner agent."
  value       = aws_security_group.runner.id
}

output "runner_sg_id" {
  description = "ID of the security group attached to the docker machine runners."
  value       = aws_security_group.docker_machine.id
}

output "runner_eip" {
  description = "EIP of the Gitlab Runner"
  value       = element(concat(aws_eip.gitlab_runner.*.public_ip, [""]), 0)
}
