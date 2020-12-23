# Luis merino : Despliegue de una instancia multihome con varias eni
# 
# Creacion de instance profile , security groups 

resource "aws_iam_instance_profile" "instance_profile" {
  provider = aws.region-master
  name     = join("-", [var.cluster_id, "instance-profile"])
  role     = aws_iam_role.assume_role.name
}

resource "aws_iam_role" "assume_role" {
  provider           = aws.region-master
  name               = join("-", [var.cluster_id, "assume_role"])
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags = {
    Name = join("-", [var.cluster_id, "assume-role"])
  }
}

resource "aws_iam_role_policy" "role_policy" {
  provider = aws.region-master
  name     = join("-", [var.cluster_id, "role-policy"])
  role     = aws_iam_role.assume_role.id
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:AttachVolume",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "ec2:DetachVolume",
      "Resource": "*"
    },
    {
      "Action" : [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# security group , tanto para ssh como para hhttp

resource "aws_security_group" "sg-ssh" {
  provider = aws.region-master
  name     = join("-", [var.cluster_id, "sg-ssh"])
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "sg-ssh"])
  }
}

resource "aws_security_group_rule" "ssh" {
  provider          = aws.region-master
  type              = "ingress"
  security_group_id = aws_security_group.sg-ssh.id
  protocol          = "tcp"
  cidr_blocks       = [var.external_ip]
  from_port         = 22
  to_port           = 22
}
