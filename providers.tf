# Luis Merino : Despliegue de una instancia multihome con varias eni
# definimos los varios providers para futuro multiregion
provider "aws" {
  profile = var.profile
  region  = var.region-master
  alias   = "region-master"
}