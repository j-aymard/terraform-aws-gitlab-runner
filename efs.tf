resource "aws_efs_file_system" "efs" {
   creation_token = "efs-token"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
   tags = {
     Name = var.environment
   }
 }

 resource "aws_efs_mount_target" "efs-mount" {
   file_system_id  = "${aws_efs_file_system.efs.id}"
   subnet_id = var.subnet_id_runners
   security_groups = ["${aws_security_group.runner.id}"]
 }

 data "aws_efs_mount_target" "efs_by_id" {
   mount_target_id  = "${aws_efs_mount_target.efs-mount.id}"
 }

 # Allow NFS traffic from gitlab-runner agent instances and security group IDs to docker-machine instances
resource "aws_security_group_rule" "docker_machine_efs_ingress" {
  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"
  source_security_group_id = aws_security_group.docker_machine.id
  security_group_id        = aws_security_group.runner.id

  description = format(
    "Allow NFS traffic from %s to docker-machine instances in group %s on port 2049",
    aws_security_group.docker_machine.id,
    aws_security_group.runner.id
  )
}

# Allow  outgoing NFS traffic
resource "aws_security_group_rule" "docker_machine_efs_egress" {
  type      = "egress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"

  source_security_group_id = aws_security_group.runner.id
  security_group_id        = aws_security_group.docker_machine.id

  description = format(
    "Allow NFS traffic from %s to docker-machine instances in group %s on port 2049",
    aws_security_group.runner.id,
    aws_security_group.docker_machine.id
  )
}
