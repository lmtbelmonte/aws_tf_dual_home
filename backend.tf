# Luis Merino : Despliegue de una instancia multihome con varias eni

# Creacion del backend en s3

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "lmt-tf-state"
    bucket  = "lmt-tf-multihome"
  }
}