module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  map_public_ip_on_launch = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  # No private subnets, no NAT — public-only setup
  enable_nat_gateway = false
  single_nat_gateway = false

  tags = {
    Terraform = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    public_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]

      # 👇 Ensure nodes are created in public subnets
      subnet_ids = module.vpc.public_subnets

      # 👇 Optional but useful
      public_ip = true
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
