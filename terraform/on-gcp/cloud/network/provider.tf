data "sops_file" "sa-key" {
  source_file = "../sa-key.sops.json"
}

terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
    google = {
      source = "hashicorp/google"
      version = "4.5.0"
    }
  }

  backend "gcs" {
    bucket = "learning-box-369917-terraform-remote-state"
    prefix = "network"
  }
}

provider "google" {
  # Configuration options
  project = "learning-box-369917"
  region = "northamerica-northeast1"
  zone = "northamerica-northeast1-a"
  credentials = data.sops_file.sa-key.raw # the service-account to connect to learning-box project
}
