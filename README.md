
VPC Terraform Module 
Overview
This Terraform configuration sets up a Virtual Private Cloud (VPC) with public and private subnets across multiple Availability Zones (AZs) in AWS. It includes an internet gateway for public subnets and a NAT gateway to enable internet access for instances in private subnets. This architecture is scalable and follows best practices for high availability and security, making it suitable for a variety of production workloads, and future projects.

Resources Overview
1. VPC (aws_vpc.main)
A Virtual Private Cloud (VPC) that defines the network space where all other resources are deployed.
CIDR block is passed as a variable to allow for customizable address space.
DNS support and DNS hostnames are enabled for internal and external resolution.

3. Internet Gateway (aws_internet_gateway.gw)
Provides internet access to the public subnets.
Required for traffic routing from the VPC to the internet.

5. Public Subnets (aws_subnet.public_subnet_1, aws_subnet.public_subnet_2)
Two public subnets, each in different AZs for high availability.
Public subnets are associated with the internet gateway to allow instances to communicate with the internet.

7. Private Subnets (aws_subnet.private_subnet_1, aws_subnet.private_subnet_2)
Two private subnets located in different AZs, designed for internal resources such as application servers.
These subnets do not have direct internet access and are secured by routing through a NAT gateway.

9. Private Database Subnets (aws_subnet.private_db_subnet_1, aws_subnet.private_db_subnet_2)
Dedicated subnets for hosting databases in a private and isolated manner.
Located in different AZs for redundancy and failover capabilities.

11. Route Tables:
Public Route Table (aws_route_table.public)
Routes traffic to the internet via the internet gateway.
Associated with public subnets.
Private Route Table (aws_route_table.private)
Routes traffic for private subnets through the NAT gateway for outbound internet access.
Associated with both private and private database subnets.

13. Route Table Associations:
Ensures that each subnet is linked to the correct route table, providing appropriate traffic routing for public and private resources.
Includes associations for:
Public Subnets (aws_route_table_association.public_rt_1, aws_route_table_association.public_rt_2)
Private Subnets (aws_route_table_association.private_rt_1, aws_route_table_association.private_rt_2)
Private Database Subnets (aws_route_table_association.private_db_rt_1, aws_route_table_association.private_db_rt_2)

15. NAT Gateway (aws_nat_gateway.gw_1)
Provides internet access for instances in the private subnets by routing outbound traffic.
Associated with a public subnet and allows instances in private subnets to reach the internet without being exposed to inbound traffic from the internet.
Variables
cidr_block_vpc: CIDR block for the VPC.
public_subnet_1_cidr, public_subnet_2_cidr: CIDR blocks for public subnets.
private_subnet_1_cidr, private_subnet_2_cidr: CIDR blocks for private subnets.
vpc_name, internet_gateway_name: Tags for the VPC and internet gateway.
default_cidr: CIDR block for default internet routing (usually set to 0.0.0.0/0).

Usage
To use this module, provide values for the required variables in a .tfvars file or through environment variables. Example variable definitions:

cidr_block_vpc          = "10.0.0.0/16"
public_subnet_1_cidr    = "10.0.1.0/24"
public_subnet_2_cidr    = "10.0.2.0/24"
private_subnet_1_cidr   = "10.0.3.0/24"
private_subnet_2_cidr   = "10.0.4.0/24"
vpc_name                = "MyVPC"
internet_gateway_name   = "MyInternetGateway"
default_cidr            = "0.0.0.0/0"

Then initialize and apply the Terraform code:

terraform init
terraform apply

Explanation of Design
This VPC configuration is built with the following design principles in mind:

High Availability:

Resources are distributed across multiple availability zones (AZs) to ensure redundancy and resilience.
Public and Private Segregation:

Public subnets host resources that need internet access (e.g., web servers).
Private subnets isolate sensitive resources (e.g., application servers and databases) from the internet.
Internet Gateway and NAT Gateway:

Public subnets have direct internet access via the internet gateway.
Private subnets use a NAT gateway, ensuring outbound traffic while preventing inbound traffic from the internet.
Modularity:

This VPC design allows for easy expansion by adding more subnets, route tables, or even additional tiers (e.g., database layer, caching layer) to support different application architectures.
Security:

By separating public and private subnets, sensitive resources are protected from direct exposure to the internet, adhering to best practices for secure network design.

Future Enhancements
Add security groups and network ACLs for more granular security control.
Include application load balancer (ALB) and auto-scaling group (ASG) for a scalable, production-grade environment.
Integrate with monitoring services like AWS CloudWatch to track performance and health.

Conclusion
This VPC module sets up a scalable, secure, and highly available network infrastructure in AWS, providing a strong foundation for deploying applications in a production environment.
