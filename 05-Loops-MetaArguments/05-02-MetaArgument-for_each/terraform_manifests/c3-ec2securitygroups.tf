resource "aws_security_group" "ssh_sg" {
  name_prefix = "ssh-access-"
  description = "SSH access for administrative purposes"

  tags = {
    Name = "SSH Access"
    Type = "Administrative"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_sg_from_anywhere" {
  security_group_id = aws_security_group.ssh_sg.id
  from_port = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "SSH from anywhere"

  tags = {
    Name = "SSH Office Access"
  }
}

resource "aws_vpc_security_group_egress_rule" "ssh_sg_all_outbound" {
  security_group_id = aws_security_group.ssh_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All outbound traffic"
}


resource "aws_security_group" "web_sg" {
  name_prefix = "web-traffic-"
  description = "Web traffic from anywhere"

  tags = {
    Name = "Web Traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_sg_http" {
  security_group_id = aws_security_group.web_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "web_sg_https" {
  security_group_id = aws_security_group.web_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTPS from anywhere"
}

resource "aws_vpc_security_group_egress_rule" "web_sg_all_outbound" {
  security_group_id = aws_security_group.web_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All outbound traffic"
}
