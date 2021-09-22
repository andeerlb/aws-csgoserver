
output "azs" {
  value = module.aws_vpc.azs
}

output "name" {
  value = module.aws_vpc.name
}

output "id" {
  value = module.aws_vpc.vpc_id
}

output "arn" {
  value = module.aws_vpc.vpc_arn
}

output "private_subnet_ids" {
  value = module.aws_vpc.private_subnets
}

output "database_subnet_ids" {
  value = module.aws_vpc.database_subnets
}

output "public_subnet_ids" {
  value = module.aws_vpc.public_subnets
}