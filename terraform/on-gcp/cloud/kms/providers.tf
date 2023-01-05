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
    prefix = "kms"
  }
}