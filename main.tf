module "vpc_network_non_production_workload" {
  count = var.account_customizations_name == "Network_Non_Production" ? 1 : 0 
  source = "./module/vpc"
  cidr_range = "10.10.0.0/16"
  vpc_suffix = "np"
  environment = "np"
}

module "vpc_network_non_production_workload_management" {
  count = var.account_customizations_name == "Network_Non_Production" ? 1 : 0 
  source = "./module/vpc"
  cidr_range = "10.11.0.0/16"
  vpc_suffix = "mgmt-np"
  environment = "np"
}

module "vpc_network_production_workload" {
  count = var.account_customizations_name == "Network_Production" ? 1 : 0 
  source = "./module/vpc"
  cidr_range = "10.20.0.0/16"
  vpc_suffix = "prod"
  environment = "prod"
}

module "vpc_network_production_workload_management" {
  count = var.account_customizations_name == "Network_Production" ? 1 : 0 
  source = "./module/vpc"
  cidr_range = "10.21.0.0/16"
  vpc_suffix = "mgmt-prod"
  environment = "prod"
}
