variable vpc_cidr_block {
    default = "10.0.0.0/16"
}
variable subnet_cidr_block {
    default = "10.0.10.0/16"
}

variable avail_zone {
    default = "us-east-1a"
}

variable env_prefix {
    default = "dev"
}

variable my_ip {
    default = "0.0.0.0/0"
}

variable jenkins_ip {
    default = "35.172.190.238/32"
}

variable instance_type {
    default = "t2.micro"
}

variable region {
    default = "us-east-1"
}