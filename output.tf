output "elb_dns_name" {
  value       = aws_elb.elb.dns_name
  description = "This is AWS generated Load Balancer DNS name"
}

output "BastionServer_PublicIP" {
  value       = aws_instance.bastion.public_ip
  description = "This is Bastion server Public IP"
}
