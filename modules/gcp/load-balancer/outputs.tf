output "forwarding_rule_name" {
  value = google_compute_global_forwarding_rule.main.name
}

output "backend_service_name" {
  value = google_compute_backend_service.default.name
}

output "proxy_name" {
  value = google_compute_target_http_proxy.default.name
}
