variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "A name that identifies the environment, will used as prefix and for tagging."
  type        = string
  default     = "runners-st"
}

variable "runner_name" {
  description = "Name of the runner, will be used in the runner config.toml"
  type        = string
  default     = "cicd-runner"
}

variable "gitlab_url" {
  description = "URL of the gitlab instance to connect to."
  type        = string
  default     = "https://gitlab.com"
}

variable "registration_token" {
  description = "gitlab cicd token"
  type        = string
  default     = "u3bb6LQzoD_zAMX4NqDm"
}

variable "timezone" {
  description = "Name of the timezone that the runner will be used in."
  type        = string
  default     = "Europe/Paris"
}

variable "docker_machine_options" {
  description = "List of additional options for the docker machine config. Each element of this list must be a key=value pair. E.g. '[\"amazonec2-zone=a\"]'"
  type        = list(string)
  default     = [
      "amazonec2-userdata=/home/ec2-user/userdata.sh",
    ]

}

variable "runners_additional_volumes" {
  type        = list(string)
  #default     = ["/efs:/efs:rw"]
  default     = []
}



variable "enable_cloudwatch_logging" {
  default = false
}