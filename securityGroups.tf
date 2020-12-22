# Luis merino : Despliegue de una instancia multihome con varias eni
# 
# Creacion de los security groups 

resource "aws_security_group" "sg-wsv-b" {
  provider    = aws.region-master
  name        = join("-", [var.cluster_id, "sg-wsv-b"])
  description = "Permitir el trafico hacia el web server"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Permitir tcp/443 desde cualquier sitio"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permitir tcp/80 desde cualquier sitio"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Permitir salida a todo"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}