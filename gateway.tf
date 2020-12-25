# Luis merino : Despliegue de una instancia multihome con varias eni
# 
# Creacion de los los diferentes recursos de red en las dos regiones con los 2 alias de aws

# Internet gateways  
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "igw"])
  }
}

# creamos la default route table
resource "aws_route_table" "default" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "rt-default"])
  }
}

# Asociacion con  la route table default.  
resource "aws_main_route_table_association" "default-rt-assoc" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.default.id
}

# creacion de la ruta al gateway
resource "aws_route" "igw_route" {
  provider               = aws.region-master
  destination_cidr_block = var.external_ip
  route_table_id         = aws_route_table.default.id
  gateway_id             = aws_internet_gateway.igw.id
}

# creamos la routr table para la MNG-B 
resource "aws_route_table" "rt-mng-b" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "rt-MNG-B"])
  }
}

# Asociamos la route table a las subnet
resource "aws_route_table_association" "route_mng" {
  provider       = aws.region-master
  route_table_id = aws_route_table.rt-mng-b.id
  subnet_id      = aws_subnet.subnet_b3.id
}

# creamos la route table para la DB-A 
resource "aws_route_table" "rt-db-a" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "rt-DB-A"])
  }
}

# Asociamos la route table a la subnet a1
resource "aws_route_table_association" "route_dba_a" {
  provider       = aws.region-master
  route_table_id = aws_route_table.rt-db-a.id
  subnet_id      = aws_subnet.subnet_a1.id
}

# creamos la route table para la WSV-A 
resource "aws_route_table" "rt-wsv-a" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "rt-WSV-A"])
  }
}

# Asociamos la route table a la subnet a2
resource "aws_route_table_association" "route_wsv_a" {
  provider       = aws.region-master
  route_table_id = aws_route_table.rt-wsv-a.id
  subnet_id      = aws_subnet.subnet_a2.id
}

# creamos la route table para la DB-B 
resource "aws_route_table" "rt-db-b" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "rt-DB-B"])
  }
}

# Asociamos la route table a la subnet b1
resource "aws_route_table_association" "route_db_b" {
  provider       = aws.region-master
  route_table_id = aws_route_table.rt-db-b.id
  subnet_id      = aws_subnet.subnet_b1.id
}

# creamos la route table para la WSV-B 
resource "aws_route_table" "rt-wsv-b" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = join("-", [var.cluster_id, "rt-WSV-B"])
  }
}

# Asociamos la route table a la subnet b2
resource "aws_route_table_association" "route_wsv_b" {
  provider       = aws.region-master
  route_table_id = aws_route_table.rt-wsv-b.id
  subnet_id      = aws_subnet.subnet_b2.id
}
