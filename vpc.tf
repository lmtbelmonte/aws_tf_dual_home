# Luis Merino : Despliegue de una instancia multihome con varias eni

# Creacion de la VPC en us-east-1
resource "aws_vpc" "vpc" {
  provider             = aws.region-master
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = join("-", [var.cluster_id, "vpc"])
  }
}

# Subnets de la vpc para ello utilizamos un bloque data para
# recoger una lista de las AZ de esa region

data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

# creamos la primera subnet utilizando los datos de la lista para la primera az
# en la primera AZ creamos 2 subnet

resource "aws_subnet" "subnet_a1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_az1[0]
  tags = {
    Name = join("-", [var.cluster_id, "sn-DB-A"])
  }
}

# creamos la segunda subnet utilizando los datos de la lista primera az
resource "aws_subnet" "subnet_a2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_az1[1]
  tags = {
    Name = join("-", [var.cluster_id, "sn-WSV-A"])
  }
}

# creamos la segunda subnet utilizando los datos de la lista segunda az
resource "aws_subnet" "subnet_b1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_az2[0]
  tags = {
    Name = join("-", [var.cluster_id, "sn-DB-B"])
  }
}

# creamos la segunda subnet utilizando los datos de la lista segunda az
resource "aws_subnet" "subnet_b2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_az2[1]
  tags = {
    Name = join("-", [var.cluster_id, "sn-WSV-B"])
  }
}

# creamos la tercera subnet para Gestion utilizando los datos de la lista segunda az
resource "aws_subnet" "subnet_b3" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_az2[2]
  tags = {
    Name = join("-", [var.cluster_id, "sn-MNG-B"])
  }
}