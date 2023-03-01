#VPC
module "vpc" {
  source = "./modules/vpc"
  vpc    = var.vpc
}

#Bastion
module "bastion" {
  source         = "./modules/bastion"
  bastion        = var.bastion
  sg_rule        = var.bastion_sg_rule_tcp_6522
  vpc_id_pass    = module.vpc.vpc_id
  subnet_id_pass = module.vpc.subnet_id_out
}

#ALB
module "alb" {
  source            = "./modules/alb"
  alb               = var.alb
  sg_rule           = var.alb_sg_rule_tcp_80
  vpc_id_pass       = module.vpc.vpc_id
  all_public_subnet = module.vpc.all_public_subnet
}

#ASG
module "asg" {
  source             = "./modules/asg"
  asg                = var.asg
  vpc_id_pass        = module.vpc.vpc_id
  albsg_id_pass      = module.alb.alb_sg_id
  bastionsg_id_pass  = module.bastion.bastion_sg_id
  all_private_subnet = module.vpc.all_private_subnet
  target_group_arns  = module.alb.tg_arns
  web_http_rule      = var.web_sg_rule_http_80
  web_ssh_rule       = var.web_sg_rule_ssh_6522
}
