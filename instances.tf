# Luis merino : Despliegue en aws con terraform y ansible
# 
# Utilizamos data y aws SSM Parameter Store para recojerl amiid con el endpoint en cada region
# en value deja el resultado

# Primero creamos la instancia para webserver B
# Utilizamos data y aws SSM Parameter Store para recojerl amiid con el endpoint en cada region
# en value deja el resultado

data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# hay que crear el par de claves para hacer el logging en las instancias us-east-1 
resource "aws_key_pair" "dualhome-key" {
  provider   = aws.region-master
  key_name   = "dualhome-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Creamos y hacemos bootstrap de las instancia para webserver

resource "aws_instance" "dualhome-wsv-b" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.dualhome-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.sg-wsv-b.id, aws_security_group.sg-ssh.id]
  subnet_id                   = aws_subnet.subnet_b2.id

  tags = {
    Name = join("-", [var.cluster_id, "ec2-WSV-B"])
  }
}

# creacion de una eip pra la instancia web 
# la attachamos despues a la eni

resource "aws_eip" "eip-wsv" {
  provider          = aws.region-master
  vpc               = true
  network_interface = aws_network_interface.eni-wsv-b.id
  tags = {
    Name = join("-", [var.cluster_id, "eip-WSV-B"])
  }
}

# interface de red para la instancia web, le asignamos manualmente una eip
resource "aws_network_interface" "eni-wsv-b" {
  provider        = aws.region-master
  subnet_id       = aws_subnet.subnet_b2.id
  security_groups = [aws_security_group.sg-wsv-b.id, aws_security_group.sg-ssh.id]

  attachment {
    instance     = aws_instance.dualhome-wsv-b.id
    device_index = 1
  }
  tags = {
    Name = join("-", [var.cluster_id, "eni-WSV-B"])
  }
}

# Segundo interfaz de red para la instancia web, este la asociamos a la subnet MNG 
resource "aws_network_interface" "eni-mng-b" {
  provider        = aws.region-master
  subnet_id       = aws_subnet.subnet_b3.id
  security_groups = [aws_security_group.sg-mng-b.id, aws_security_group.sg-ssh.id]

  attachment {
    instance     = aws_instance.dualhome-wsv-b.id
    device_index = 2
  }
  tags = {
    Name = join("-", [var.cluster_id, "eni-MNG-B"])
  }
}