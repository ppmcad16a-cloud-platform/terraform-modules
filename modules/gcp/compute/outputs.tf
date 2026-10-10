output "instance_name" {
  value = google_compute_instance.server.name
}

output "instance_ip" {
  value = google_compute_instance.server.network_interface[0].network_ip
}
