module "webapp" { 
    source = "../../../modules/03-webapp"
    name_prefix = "terraform-poc"
    network_remote_state_bucket = var.remote_state_bucket
    sg_ingress_rules = [
        {
            from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"]
        },
        {
            from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}
