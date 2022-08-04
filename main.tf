# terraform {
#     required_providers {
#         aws = {
#             source = "hashicorp/aws"
#             version = "~> 3.0"
#         }
#     }
# }

# provider "aws" {
#     region = "ap-northeast-1"
# }

# resource "aws_vpc" "EC2VPC" {
#     cidr_block = "10.0.0.0/16"
#     enable_dns_support = true
#     enable_dns_hostnames = true
#     instance_tenancy = "default"
#     tags {
#         Name = "VPC for Ucmsapp"
#     }
# }

# resource "aws_route_table" "EC2RouteTable" {
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     tags {
#         Name = "Public_root_table"
#     }
# }

# resource "aws_route" "EC2Route" {
#     destination_cidr_block = "0.0.0.0/0"
#     gateway_id = "igw-01a963d77d1a13e73"
#     route_table_id = "rtb-0328ce460a6e3e452"
# }

# resource "aws_subnet" "EC2Subnet" {
#     availability_zone = "ap-northeast-1a"
#     cidr_block = "10.0.3.0/24"
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     map_public_ip_on_launch = false
# }

# resource "aws_subnet" "EC2Subnet2" {
#     availability_zone = "ap-northeast-1c"
#     cidr_block = "10.0.1.0/24"
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     map_public_ip_on_launch = false
# }

# resource "aws_subnet" "EC2Subnet3" {
#     availability_zone = "ap-northeast-1a"
#     cidr_block = "10.0.0.0/24"
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     map_public_ip_on_launch = false
# }

# resource "aws_subnet" "EC2Subnet4" {
#     availability_zone = "ap-northeast-1c"
#     cidr_block = "10.0.2.0/24"
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     map_public_ip_on_launch = false
# }

# resource "aws_eip" "EC2EIP" {
#     vpc = true
#     instance = "i-00d47bdc4ca48f818"
# }

# resource "aws_network_interface" "EC2NetworkInterface" {
#     description = "Primary network interface"
#     private_ips = [
#         "10.0.2.10"
#     ]
#     subnet_id = "subnet-0bea197da9a46e092"
#     source_dest_check = true
#     security_groups = [
#         "${aws_security_group.EC2SecurityGroup3.id}"
#     ]
# }

# resource "aws_network_interface" "EC2NetworkInterface2" {
#     description = "Primary network interface"
#     private_ips = [
#         "10.0.1.10"
#     ]
#     subnet_id = "subnet-05b2638deeed558a7"
#     source_dest_check = true
#     security_groups = [
#         "${aws_security_group.EC2SecurityGroup.id}"
#     ]
# }

# resource "aws_network_interface" "EC2NetworkInterface3" {
#     description = "ELB app/ucmsapp-alb/65132a64d3888e29"
#     private_ips = [
#         "10.0.1.235"
#     ]
#     subnet_id = "subnet-05b2638deeed558a7"
#     source_dest_check = true
#     security_groups = [
#         "${aws_security_group.EC2SecurityGroup2.id}"
#     ]
# }

# resource "aws_network_interface" "EC2NetworkInterface4" {
#     description = "RDSNetworkInterface"
#     private_ips = [
#         "10.0.2.164"
#     ]
#     subnet_id = "subnet-0bea197da9a46e092"
#     source_dest_check = true
#     security_groups = [
#         "${aws_security_group.EC2SecurityGroup3.id}"
#     ]
# }

# resource "aws_network_interface" "EC2NetworkInterface5" {
#     description = "ELB app/ucmsapp-alb/65132a64d3888e29"
#     private_ips = [
#         "10.0.0.195"
#     ]
#     subnet_id = "subnet-0c01baf3cbff77184"
#     source_dest_check = true
#     security_groups = [
#         "${aws_security_group.EC2SecurityGroup2.id}"
#     ]
# }

# resource "aws_instance" "EC2Instance" {
#     ami = "ami-02892a4ea9bfa2192"
#     instance_type = "t2.micro"
#     key_name = "myapp-key"
#     availability_zone = "ap-northeast-1c"
#     tenancy = "default"
#     subnet_id = "subnet-05b2638deeed558a7"
#     ebs_optimized = false
#     vpc_security_group_ids = [
#         "${aws_security_group.EC2SecurityGroup.id}"
#     ]
#     source_dest_check = true
#     root_block_device {
#         volume_size = 16
#         volume_type = "gp2"
#         delete_on_termination = true
#     }
#     tags {
#         Name = "Web_server"
#     }
# }

# resource "aws_security_group" "EC2SecurityGroup" {
#     description = "web_security_group"
#     name = "WEB-SG"
#     tags {}
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     ingress {
#         security_groups = [
#             "${aws_security_group.EC2SecurityGroup2.id}"
#         ]
#         from_port = 80
#         protocol = "tcp"
#         to_port = 80
#     }
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = 22
#         protocol = "tcp"
#         to_port = 22
#     }
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = -1
#         protocol = "icmp"
#         to_port = -1
#     }
#     egress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         protocol = "-1"
#     }
# }

# resource "aws_s3_bucket" "S3Bucket" {
#     bucket = "ucmsapp"
# }

# resource "aws_db_instance" "RDSDBInstance" {
#     identifier = "database-ucmsapp"
#     allocated_storage = 20
#     instance_class = "db.t2.micro"
#     engine = "postgres"
#     username = "ucms_app"
#     password = "REPLACEME"
#     backup_window = "16:11-16:41"
#     backup_retention_period = 7
#     availability_zone = "ap-northeast-1c"
#     maintenance_window = "thu:18:55-thu:19:25"
#     multi_az = false
#     engine_version = "12.7"
#     auto_minor_version_upgrade = true
#     license_model = "postgresql-license"
#     publicly_accessible = false
#     storage_type = "gp2"
#     port = 5432
#     storage_encrypted = false
#     copy_tags_to_snapshot = true
#     monitoring_interval = 0
#     iam_database_authentication_enabled = false
#     deletion_protection = false
#     db_subnet_group_name = "ucmsapp-db-subnet-group"
#     vpc_security_group_ids = [
#         "${aws_security_group.EC2SecurityGroup3.id}"
#     ]
#     max_allocated_storage = 1000
# }

# resource "aws_db_subnet_group" "RDSDBSubnetGroup" {
#     description = "DB Subnet Group for ucmsapp"
#     name = "ucmsapp-db-subnet-group"
#     subnet_ids = [
#         "subnet-0824f5bb5c0430886",
#         "subnet-0bea197da9a46e092"
#     ]
# }

# resource "aws_security_group" "EC2SecurityGroup3" {
#     description = "database_security_group"
#     name = "DTBS-SG"
#     tags {}
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = 5432
#         protocol = "tcp"
#         to_port = 5432
#     }
#     ingress {
#         ipv6_cidr_blocks = [
#             "::/0"
#         ]
#         from_port = 5432
#         protocol = "tcp"
#         to_port = 5432
#     }
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         description = ""
#         from_port = 22
#         protocol = "tcp"
#         to_port = 22
#     }
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = -1
#         protocol = "icmp"
#         to_port = -1
#     }
#     egress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         protocol = "-1"
#     }
# }

# resource "aws_lb" "ElasticLoadBalancingV2LoadBalancer" {
#     name = "ucmsapp-alb"
#     internal = false
#     load_balancer_type = "application"
#     subnets = [
#         "subnet-05b2638deeed558a7",
#         "subnet-0c01baf3cbff77184"
#     ]
#     security_groups = [
#         "${aws_security_group.EC2SecurityGroup2.id}"
#     ]
#     ip_address_type = "ipv4"
#     access_logs {
#         enabled = false
#         bucket = ""
#         prefix = ""
#     }
#     idle_timeout = "60"
#     enable_deletion_protection = "false"
#     enable_http2 = "true"
# }

# resource "aws_security_group" "EC2SecurityGroup2" {
#     description = "alb-security-group"
#     name = "ALB-SG"
#     tags {}
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = 80
#         protocol = "tcp"
#         to_port = 80
#     }
#     ingress {
#         ipv6_cidr_blocks = [
#             "::/0"
#         ]
#         from_port = 80
#         protocol = "tcp"
#         to_port = 80
#     }
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = 22
#         protocol = "tcp"
#         to_port = 22
#     }
#     ingress {
#         cidr_blocks = [
#             "0.0.0.0/0"
#         ]
#         from_port = 443
#         protocol = "tcp"
#         to_port = 443
#     }
#     ingress {
#         ipv6_cidr_blocks = [
#             "::/0"
#         ]
#         from_port = 443
#         protocol = "tcp"
#         to_port = 443
#     }
#     egress {
#         security_groups = [
#             "sg-00fd48aef94ec22be"
#         ]
#         from_port = 80
#         protocol = "tcp"
#         to_port = 80
#     }
# }

# resource "aws_lb_target_group" "ElasticLoadBalancingV2TargetGroup" {
#     health_check {
#         interval = 30
#         path = "/"
#         port = "traffic-port"
#         protocol = "HTTP"
#         timeout = 5
#         unhealthy_threshold = 2
#         healthy_threshold = 5
#         matcher = "301"
#     }
#     port = 80
#     protocol = "HTTP"
#     target_type = "instance"
#     vpc_id = "${aws_vpc.EC2VPC.id}"
#     name = "ucmsapp-target-group"
# }

# resource "aws_route53_zone" "Route53HostedZone" {
#     name = "ucmsapp.com."
# }

# resource "aws_route53_record" "Route53RecordSet" {
#     name = "ucmsapp.com."
#     type = "NS"
#     ttl = 172800
#     records = [
#         "ns-1260.awsdns-29.org.",
#         "ns-34.awsdns-04.com.",
#         "ns-1819.awsdns-35.co.uk.",
#         "ns-570.awsdns-07.net."
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet2" {
#     name = "ucmsapp.com."
#     type = "SOA"
#     ttl = 900
#     records = [
#         "ns-1260.awsdns-29.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet3" {
#     name = "www.ucmsapp.com."
#     type = "A"
#     alias {
#         name = "dualstack.ucmsapp-alb-315159904.ap-northeast-1.elb.amazonaws.com."
#         zone_id = "Z14GRHDCWA56QT"
#         evaluate_target_health = false
#     }
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet4" {
#     name = "www.ucmsapp.com."
#     type = "MX"
#     ttl = 1800
#     records = [
#         "10 inbound-smtp.us-east-1.amazonaws.com"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet5" {
#     name = "www.ucmsapp.com."
#     type = "TXT"
#     ttl = 300
#     records = [
#         "\"v=spf1 include:mailgun.org ~all\""
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet6" {
#     name = "_amazonses.www.ucmsapp.com."
#     type = "TXT"
#     ttl = 1800
#     records = [
#         "\"6itsDRro6ixCCgdtms8njG0i7k7plAt+H3nTgMrlvw0=\""
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet7" {
#     name = "_b9dde05b23ac44b0b8c14c900770ce7e.www.ucmsapp.com."
#     type = "CNAME"
#     ttl = 300
#     records = [
#         "_904e73bf9d6f00f58df79bed1ac2e9cb.fsdcfjjflr.acm-validations.aws."
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet8" {
#     name = "5s65taipiynmhsabupz3ravkmfkbo6qk._domainkey.www.ucmsapp.com."
#     type = "CNAME"
#     ttl = 1800
#     records = [
#         "5s65taipiynmhsabupz3ravkmfkbo6qk.dkim.amazonses.com"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet9" {
#     name = "dy6q7ihawj7ypnrv25zrnddwwjhkrbpr._domainkey.www.ucmsapp.com."
#     type = "CNAME"
#     ttl = 1800
#     records = [
#         "dy6q7ihawj7ypnrv25zrnddwwjhkrbpr.dkim.amazonses.com"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet10" {
#     name = "ha6fy7mwo525kqhf6xp5drudfmzzijhl._domainkey.www.ucmsapp.com."
#     type = "CNAME"
#     ttl = 1800
#     records = [
#         "ha6fy7mwo525kqhf6xp5drudfmzzijhl.dkim.amazonses.com"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet11" {
#     name = "mx._domainkey.www.ucmsapp.com."
#     type = "TXT"
#     ttl = 300
#     records = [
#         "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCn3Kw7hrFfT6hXG8DPNeny5G6zgwMsv8jeDH48xlg6jtBt1Ip0G1YjNrYE7wJLWe2fiJk5XqQlus46LzKSO/WzSmZjiupvBy92bbDsj0D/NUbPpWLPONLAkB57hhegBdY2rSU++QCqnS+prrrbqjbCsMMiKOumnLG0ghzSkozOlwIDAQAB\""
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet12" {
#     name = "email.www.ucmsapp.com."
#     type = "CNAME"
#     ttl = 300
#     records = [
#         "mailgun.org"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet13" {
#     name = "mail.www.ucmsapp.com."
#     type = "MX"
#     ttl = 300
#     records = [
#         "10 feedback-smtp.ap-northeast-1.amazonses.com"
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_route53_record" "Route53RecordSet14" {
#     name = "mail.www.ucmsapp.com."
#     type = "TXT"
#     ttl = 300
#     records = [
#         "\"v=spf1 include:amazonses.com ~all\""
#     ]
#     zone_id = "Z0739034BNW2RADZN24B"
# }

# resource "aws_key_pair" "EC2KeyPair" {
#     public_key = "REPLACEME"
#     key_name = "myapp-key"
# }

# resource "aws_key_pair" "EC2KeyPair2" {
#     public_key = "REPLACEME"
#     key_name = "start-aws-keypair"
# }
