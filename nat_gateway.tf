# Luis merino : Despliegue de una instancia multihome con varias eni
# 
# Creacion de NAT gateway

# creacion de la eip para el nat
resource "aws_eip" "eip-nat" {
  provider = aws.region-master
  vpc      = true
  # network_interface = aws_network_interface.eni-wsv-b.id
  tags = {
    Name = join("-", [var.cluster_id, "eip-NAT-B"])
  }
}

# creacion del nat

resource "aws_nat_gateway" "nat" {
  provider      = aws.region-master
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.subnet_b2.id

  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = join("-", [var.cluster_id, "GW-NAT-B"])
  }
}