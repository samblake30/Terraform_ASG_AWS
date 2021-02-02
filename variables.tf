#Variable Declaration for VPC
variable "vpccidr" {
  type = string
}

variable "instancetenancy" {
  type = string
}

variable "dnssupport" {
  type = bool
}

variable "dnshostname" {
  type = bool
}

#Variable Declaration for Private subnet
variable "prisubnetcidr" {
  type = string
}

variable "az" {
  type = string
}

#Variable Declaration for Public subnet
variable "pubsubnetcidr" {
  type = string
}

#Route info for Public subnet
variable "rtpub" {
  type = string
}

#Route Info for Private subnet
variable "rtpri" {
  type = string
}

#Compute Security Group ingress rules
variable "sgingress_port" {
  type = list(number)
}

#Compute Security Group egress rules
variable "sgegress_port" {
  type = list(number)
}

#Compute Security Group CIDR's
variable "cidr" {
  description = "Inbound Connection to backend from ELB"
  type        = list
}

#Compute Security Group egress CIDR's
variable "egresscidr" {
  description = "Outbound Connection to ELB"
  type        = list
}
#Key Value pair
variable "keypair" {
  type = string
}

#Instance Type for compute
variable "instance_type" {
  type = string
}

#Data Source for used AMI
variable "ami" {
  type = string
}

#Launch Configuration lifecyle rule
variable "lcrule" {
  type = bool
}

#Max instances allowed by ASG
variable "max_instance" {
  type = number
}

#Min instances allowed by ASG
variable "min_instance" {
  type = number
}

#ELB security group ingress rules
variable "elbsgingress_port" {
  type = list(number)
}

#ELB security group egress rules
variable "sgelbegress_port" {
  type = list(number)
}

#CIDR for ELB
variable "elbcidr" {
  description = "Incoming connections from client"
  type        = list
}

#Egress CIDR for ELB
variable "elbegresscidr" {
  description = "Connection to Backend Instances of ASG"
  type        = list
}

#Secodary Volume size
variable "size" {
  description = "This is size for the Data volume"
  type        = number
}

#Delete secondary volume on termination with instance
variable "dot" {
  type = bool
}

#Auto-Scaling Policy parameters
variable "cooldown" {
  type = number
}

variable "period" {
  type = number
}

variable "up_threshold" {
  type = number
}

variable "down_threshold" {
  type = number
}
