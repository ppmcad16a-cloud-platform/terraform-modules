output "instance_group_self_link" {
  value = google_compute_instance_group_manager.default.instance_group
}

output "instance_group_name" {
  value = google_compute_instance_group_manager.default.name
}
