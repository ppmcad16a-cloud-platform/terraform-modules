# Instance Template
variable "name" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "source_image" {
  type = string
}

variable "zone" {
  type = string
}

variable "target_size" {
  type = number
}

variable "tags" {
  type = list(string)
  default = []
}

resource "google_compute_instance_template" "default" {
  name         = "${var.name}-template"
  machine_type = var.machine_type

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  tags = var.tags
}

# Managed Instance Group
resource "google_compute_instance_group_manager" "default" {
  name               = "${var.name}-group"
  base_instance_name = "${var.name}-server"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.default.self_link
  }

  target_size = var.target_size
}
