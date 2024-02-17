module "vpc_network_non_production" {
  count = var.account == "Network_Non_Production" ? 1 : 0 
  source = "./module/vpc"
  cidr_range = "10.10.0.0/16"
  vpc_name = "VPC - NP"
  environment = "np"
}

module "vpc_network_production" {
  count = var.account == "Network_Production" ? 1 : 0 
  source = "./module/vpc"
  cidr_range = "10.20.0.0/16"
  vpc_name = "VPC - Prod"
  environment = "prod"
}
