locals {
  environment_vars = jsondecode(file("${path_relative_to_include()}/params.json"))
  stage            = local.environment_vars.environment
}

# Generate an k8s provider block. You can run `minikube ip` to get the local ip address.
# And run `minikube config view` to get the certificates and key
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "2.10.0"
        }
        helm = {
          source = "hashicorp/helm"
          version = "2.5.1"
        }
        kubectl = {
          source = "gavinbunney/kubectl"
          version = "1.14.0"
        }
      }
    }

    provider "kubernetes" {
      config_path = "~/.kube/config"
    }

    provider "helm" {
      kubernetes {
        config_path = "~/.kube/config"
      }
    }

    provider "kubectl" {
      config_path = "~/.kube/config"
    }

EOF
}

terraform {
    source = "../../terraform//"
}

inputs = merge (
  local.environment_vars,
  local
)