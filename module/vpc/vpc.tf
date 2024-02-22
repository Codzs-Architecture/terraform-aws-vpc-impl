data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name   = "vpc-${var.vpc_suffix}"
  region = data.aws_region.current.name

  vpc_cidr = var.cidr_range
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  network_acls = {
    default_inbound = [
      {
        rule_number = 890
        rule_action = "allow"
        from_port   = 1024
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 900
        rule_action     = "allow"
        from_port       = 1024
        to_port         = 65535
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
    default_outbound = [
      {
        rule_number = 890
        rule_action = "allow"
        from_port   = 32768
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 900
        rule_action     = "allow"
        from_port       = 32768
        to_port         = 65535
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
    public_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 110
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 130
        rule_action     = "allow"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
      {
        rule_number = 140
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
    public_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 110
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 130
        rule_action     = "allow"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
      {
        rule_number = 140
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "10.10.100.0/22"
      },
      {
        rule_number     = 150
        rule_action     = "allow"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
    private_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 110
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      }
    ]
    private_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 110
        rule_action     = "allow"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      }
    ]
    database_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 110
        rule_action     = "allow"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      },
    ]
    database_outbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number     = 110
        rule_action     = "allow"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        ipv6_cidr_block = "::/0"
      }
    ]
  }

  tags = var.tags
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "Codzs-Architecture/vpc/aws"
  version = "5.5.3"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  # intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 20)]
  # elasticache_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 12)]
  # redshift_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 16)]

  public_subnet_names   = ["public-subnet-one-${var.vpc_suffix}", "public-subnet-two-${var.vpc_suffix}", "public-subnet-three-${var.vpc_suffix}"]
  private_subnet_names  = ["application-subnet-one-${var.vpc_suffix}", "application-subnet-two-${var.vpc_suffix}", "application-subnet-three-${var.vpc_suffix}"]
  database_subnet_names = ["db-subnet-one-${var.vpc_suffix}", "db-subnet-two-${var.vpc_suffix}", "db-subnet-three-${var.vpc_suffix}"]
  # intra_subnet_names       = ["Infra Subnet One - ${var.vpc_suffix}", "Infra Subnet Two - ${var.environment}", "Infra Subnet Three - ${var.environment}"]
  # elasticache_subnet_names = ["Elasticache Subnet One", "Elasticache Subnet Two"]
  # redshift_subnet_names    = ["Redshift Subnet One", "Redshift Subnet Two", "Redshift Subnet Three"]

  create_database_subnet_group  = false
  manage_default_route_table    = false
  manage_default_security_group = false

  manage_default_network_acl = true

  public_dedicated_network_acl = true
  public_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["public_inbound"])
  public_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["public_outbound"])

  private_dedicated_network_acl = true
  private_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["private_inbound"])
  private_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["private_outbound"])

  database_dedicated_network_acl = true
  database_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["database_inbound"])
  database_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["database_outbound"])

  redshift_dedicated_network_acl    = false
  elasticache_dedicated_network_acl = false
  intra_dedicated_network_acl       = false
  outpost_dedicated_network_acl     = false

  create_database_subnet_route_table    = true
  create_elasticache_subnet_route_table = false
  create_redshift_subnet_route_table    = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false
  single_nat_gateway = true

  # To be configured for VPN Connection
  # customer_gateways = {
  #   IP1 = {
  #     bgp_asn     = 65112
  #     ip_address  = "1.2.3.4"
  #     device_name = "some_name"
  #   },
  #   IP2 = {
  #     bgp_asn    = 65112
  #     ip_address = "5.6.7.8"
  #   }
  # }

  enable_vpn_gateway = false

  # TODO: 
  enable_dhcp_options              = false
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = local.tags
}

################################################################################
# VPC Endpoints Module
################################################################################

# module "vpc_endpoints" {
#   source  = "Codzs-Architecture/vpc/aws//modules/vpc-endpoints"
#   version = "5.5.3"

#   vpc_id = module.vpc.vpc_id

#   create_security_group      = true
#   security_group_name_prefix = "${local.name}-vpc-endpoints-"
#   security_group_description = "VPC endpoint security group"
#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [module.vpc.vpc_cidr_block]
#     }
#   }

#   endpoints = {
#     ecs_telemetry = {
#       create              = false
#       service             = "ecs-telemetry"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc.private_subnets
#     },
#   }

#   tags = local.tags
# }

# module "vpc_endpoints_nocreate" {
#   source  = "Codzs-Architecture/vpc/aws//modules/vpc-endpoints"
#   version = "5.5.3"

#   create = false
# }