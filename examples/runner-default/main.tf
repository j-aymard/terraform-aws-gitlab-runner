data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70"

  name = "vpc-${var.environment}"
  cidr = "172.17.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0]]
  private_subnets = ["172.17.1.0/24"]
  public_subnets  = ["172.17.101.0/24"]

  enable_dns_support = true

  enable_nat_gateway = true
  enable_vpn_gateway = true

  single_nat_gateway = true
  enable_s3_endpoint = false

  tags = {
    Environment = var.environment
  }
}

module "runner" {
  source = "../../"

  aws_region  = var.aws_region
  environment = var.environment

  vpc_id                   = module.vpc.vpc_id
  subnet_ids_gitlab_runner = module.vpc.private_subnets
  subnet_id_runners        = element(module.vpc.private_subnets, 0)
  metrics_autoscaling      = ["GroupDesiredCapacity", "GroupInServiceCapacity"]

  runners_name             = var.runner_name
  runners_gitlab_url       = var.gitlab_url
  enable_runner_ssm_access = true

  efs_ip = module.efs.ip  

  gitlab_runner_security_group_ids = [data.aws_security_group.default.id]

  docker_machine_download_url   = "https://gitlab-docker-machine-downloads.s3.amazonaws.com/v0.16.2-gitlab.2/docker-machine"
  docker_machine_spot_price_bid = "on-demand-price"

  gitlab_runner_registration_config = {
    registration_token = var.registration_token
    tag_list           = "docker_spot_runner"
    description        = "runner default - auto"
    locked_to_project  = "true"
    run_untagged       = "true"
    maximum_timeout    = "3600"
  }

  tags = {
    "tf-aws-gitlab-runner:example"           = "runner-default"
    "tf-aws-gitlab-runner:instancelifecycle" = "spot:yes"
  }

  runners_privileged         = "true"
  runners_additional_volumes = ["/efs:/efs:rw"]
  docker_machine_options = ["amazonec2-userdata=/home/ec2-user/userdata.sh"]

  runners_volumes_tmpfs = [
    {
      volume  = "/var/opt/cache",
      options = "rw,noexec"
    }
  ]

  runners_services_volumes_tmpfs = [
    {
      volume  = "/var/lib/mysql",
      options = "rw,noexec"
    }
  ]
  

  # working 9 to 5 :)
  runners_machine_autoscaling = [
    {
      periods    = ["\"* * 0-9,22-23 * * mon-fri *\"", "\"* * * * * sat,sun *\""]
      idle_count = 0
      idle_time  = 60
      timezone   = var.timezone
    }
  ]

  runners_pre_clone_script = <<EOT
  '''
  command -v ssh-agent >/dev/null || ( yum check-update -y && yum install openssh-client -y )
  eval $(ssh-agent -s)
  echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
  chmod 644 ~/.ssh/known_hosts
  '''
  EOT

  runners_post_build_script = "\"echo 'single line'\""
}

resource "null_resource" "cancel_spot_requests" {
  # Cancel active and open spot requests, terminate instances
  triggers = {
    environment = var.environment
  }

  provisioner "local-exec" {
    when    = destroy
    command = "../../bin/cancel-spot-instances.sh ${self.triggers.environment}"
  }
}



################################################################################
### AWS template launcher for agent
################################################################################
module "agent_launch_template" {
  source          = "../../modules/agent_template_launcher"
  efs_ip = module.efs.ip
  subnet_id = module.vpc.private_subnets[0]
  security_group_ids = [module.runner.runner_sg_id]
}

################################################################################
### AWS EFS
################################################################################
module "efs" {
  source          = "../../modules/efs"
  environment = var.environment
  security_group = module.runner.runner_agent_sg_id
  subnet_id = element(module.vpc.private_subnets, 0)
}

