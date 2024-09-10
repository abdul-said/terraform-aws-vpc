
variable "cidr_block_vpc" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "main"
}

variable "internet_gateway_name" {
  default = "main"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.10.0/24"
}

variable "allow_http_public" {
  default = "80"
}

variable "allow_https_public" {
  default = "443"
}

variable "default_cidr" {
  default = "0.0.0.0/0"
}

/*variable "public_subnets" {
  type = map(object({
    cidr_block = string
    availability_zone = string
    is_private = bool
  }))
  default = {
    public_1 = {
      cidr_block        = "10.0.1.0/24",
      availability_zone = "eu-west-2a"
      is_private        = false
      }

    public_2 = {
      cidr_block        = "10.0.2.0/24",
      availability_zone = "eu-west-2b"
      is_private        = false
      }

    public_3 = {
      cidr_block        = "10.0.3.0/24",
      availability_zone = "eu-west-2c"
      is_private        = false
      }

    private_1 = {
      cidr_block        = "10.0.10.0/24",
      availability_zone = "eu-west-2a"
      is_private        = true
      }

    private_2 = {
      cidr_block        = "10.0.11.0/24",
      availability_zone = "eu-west-2b"
      is_private        = true
      
      }

    private_3 = {
      cidr_block        = "10.0.12.0/24",
      availability_zone = "eu-west-2c" 
      is_private        = true
      }
  }

}*/



