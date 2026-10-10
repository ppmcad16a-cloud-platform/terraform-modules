variable "name" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "zone" {
  type = string
}

variable "subnetwork" {
  type = string
}
