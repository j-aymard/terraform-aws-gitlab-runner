variable "aws_region" {
  description = "AWS region."
  type        = string
  default = "eu-west-2"
}

variable "efs_ip" {
  description = "AWS EFS's IP"
  type        = string
  default = "10.0.1.158"
}

variable "agent_ami_id" {
  description = "Agent AWS image AMI id "
  type        = string
  default = "ami-0d37e07bd4ff37148"
}

variable "agent_subnet_id" {
  description = "Agent AWS subnet id"
  type        = string
  default = "subnet-07a6a96689709a59a"
}

variable "agent_security_group_ids" {
  description = "A list of security group ids that are allowed to access the gitlab runner agent"
  type        = list(string)
  default     = ["sg-07f33c9e9e0071c87"]
}





