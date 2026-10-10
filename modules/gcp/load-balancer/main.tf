# Health Check
resource "google_compute_http_health_check" "default" {
  name = "${var.name}-hc"
}

# Backend Service
resource "google_compute_backend_service" "default" {
  name        = "${var.name}-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  backend {
    group = var.instance_group
  }

  health_checks = [google_compute_http_health_check.default.self_link]
}

# URL Map
resource "google_compute_url_map" "default" {
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.default.self_link
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name}-proxy"
  url_map = google_compute_url_map.default.self_link
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "main" {
  name       = "${var.name}-fwd"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
}
