resource "google_storage_bucket" "main" {
  name     = var.name
  location = "US"
}
