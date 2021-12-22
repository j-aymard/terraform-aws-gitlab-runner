variable "aws_region" {
  description = "AWS region."
  type        = string
  default = "eu-west-2"
}

variable "efs_ip" {
  description = "AWS EFS's IP"
  type        = string
  default = "10.0.1.21"
}

variable "ami_id" {
  description = "Agent AWS image AMI id "
  type        = string
  default = "ami-0d37e07bd4ff37148"
}

variable "subnet_id" {
  description = "Agent AWS subnet id"
  type        = string
  default = "subnet-04943c90441490afd"
}

variable "security_group_ids" {
  description = "A list of security group ids that are allowed to access the gitlab runner agent"
  type        = list(string)
  default     = ["sg-08b4480f91b9edda2"]
}

variable "iam_role" {
  description = "A list of security group ids that are allowed to access the gitlab runner agent"
  type        = string
  default     = "runners-st-instance"
}





