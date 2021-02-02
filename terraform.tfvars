#Variable Values for VPC
vpccidr         = "10.0.0.0/16"
instancetenancy = "default"
dnssupport      = true
dnshostname     = true

#Variable Values for Private subnet
prisubnetcidr = "10.0.1.0/24"

#Common for Private and Public subnet
az = "ap-south-1b"

#Variable Values for Public subnet
pubsubnetcidr = "10.0.0.0/24"

#Variable Value for Route addition in public subnet RT
rtpub = "0.0.0.0/0"

#Variable Value for Route addition in Private Subnet RT
rtpri = "0.0.0.0/0"

#Variable Value for Ingress traffic in compute security group
sgingress_port = [80, 22]

#Variable Value for Egress Traffic in Compute Security group
sgegress_port = [0]

#Variable Value for the CIDR rules in Compute Security Group
cidr = ["10.0.0.0/24", "0.0.0.0/0"]

#Variable Value for the Egress CIDR rules in COmpute Security group
egresscidr = ["0.0.0.0/0"]

#Variable Value for Key-Pair addition
keypair = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMs/P+uI/akuXusckArMPNX1OluKmJ15sj++KWwdWfBqkJSMHyUzqOusOSx/Oe8hhrQ5LCnNMjzRJMJtZkUzRdwRLS/PeytjjIkwbxPXH/szULoD0K8RoptD9BFBblQJyjnFWYmb9lqXcaUAUQGMJc4W0kNhL3SL7LcnX/sEbt4uejZ8gXBP9wPQzEd6dzJoLoLkHMCoogId2mBFHCykJfh/Lg7G7raXNqt3Tg8hlcGe6uiKcAMROracJDvVYOyKnw6q1Xq1aB7E0Eise8Ib+d/PU2WNcO0lqDT4+20zlXjx1flBqFurUfty9T8fjee39Hh/i8CncPXAJ5Rdei+ZDP imported-openssh-key"

#Variable Value for Instance Type
instance_type = "t2.micro"

#Variable Value for ami
ami = "RHEL-8.3.0_HVM-20201031-x86_64-0-Hourly2-GP2"

#Variable Value for Lifecyle policy in Lauch config
lcrule = true

#Variable value for max_instance in ASG
max_instance = 10

#Variable Value for min_instance in ASG
min_instance = 1

#Variable Value for port allowed as ingress in ELB security group
elbsgingress_port = [80]

#Variable Value for port allowed as egress in ELB security group
sgelbegress_port = [0]

#Variable Value for Ingress CIDR allowed in ELB SG
elbcidr = ["0.0.0.0/0"]

#Variable Value for Egress CIDR allowed in ELB SG
elbegresscidr = ["0.0.0.0/0"]

#Variable Value Secondary volume size
size = 20

#Variable Value for the Delete on Termination of instance(DOT)
dot = true

#Variable Value for the ASG Policy Parameters
cooldown       = 300
period         = 120
up_threshold   = 50
down_threshold = 30
