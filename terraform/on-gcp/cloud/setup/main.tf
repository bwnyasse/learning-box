terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.47.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "learning-box-369917"
  region = "northamerica-northeast1"
  zone = "northamerica-northeast1-a"
  credentials = "sa-key.json" # the service-account to connect to learning-box project
}

resource "google_storage_bucket" "GCS1"{
  name       = "udemy_tf_learningbox_gcs_1"
  location   = "northamerica-northeast1"
}