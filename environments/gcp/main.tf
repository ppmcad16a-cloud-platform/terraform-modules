provider "google" {
  project = "multi-cloud-507011"
  region  = "us-central1"
  zone    = "us-central1-a"
}


module "vpc" {
  source = "../../modules/gcp/vpc"
  name   = "multi-cloud-vpc"
}


module "subnet" {
  source     = "../../modules/gcp/subnet"
  name       = "multi-cloud-subnet"
  cidr_range = "10.0.1.0/24"
  region     = "us-central1"
  network    = module.vpc.network_name
}


module "firewall" {
  source  = "../../modules/gcp/firewall"
  name    = "multi-cloud-firewall"
  network = module.vpc.network_name
}

module "compute" {
  source       = "../../modules/gcp/compute"
  name         = "multi-cloud-server"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  subnetwork   = module.subnet.subnet_name
}

module "instance_group" {
  source       = "../../modules/gcp/instance-group"
  name         = "multi-cloud-server"
  subnetwork   = module.subnet.subnet_name
  zone         = "us-central1-a"
  target_size = 2
  machine_type = "e2-micro"
  source_image = "debian-cloud/debian-12"
}

module "load_balancer" {
  source         = "../../modules/gcp/load-balancer"
  name           = "multi-cloud-lb"
  instance_group = module.instance_group.instance_group_self_link
}


module "storage" {
  source = "../../modules/gcp/storage"
  name   = "multi-cloud-terraform-16a"
}
