# Luis merino : Despliegue de una instancia multihome con varias eni
# 
# Creacion de los security groups 

# Primero para el webserver

resource "aws_security_group" "sg-wsv-b" {
  provider    = aws.region-master
  name        = join("-", [var.cluster_id, "sg-wsv-b"])
  description = "Permitir el trafico hacia el web server"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = join("-", [var.cluster_id, "sg-WSV-B"])
  }
}

# Segundo para la mng subnet

resource "aws_security_group" "sg-mng-b" {
  provider    = aws.region-master
  name        = join("-", [var.cluster_id, "sg-mng-b"])
  description = "Permitir el trafico hacia la sn de mng"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = join("-", [var.cluster_id, "sg-MNG-B"])
  }
}