![Deploying Wordpress on K8s](https://github.com/katzefudder/wordpress_minikube/workflows/Deploying%20Wordpress%20on%20Kubernetes/badge.svg)

# Wordpress on Kubernetes - K3D

Infrastructure as Code (IaC): Terraform & Terragrunt
Regarding Kubernetes, I am using K3d as a local Kubernetes environment. Helm helps me to deploy a fully fledged Loki for logs, Prometheus and Grafana for monitoring.

## Terraform

Using [Terraform](https://www.terraform.io), one is able to deliver infrastructure as code. With Terraform, I am able to control the whole stack and to keeping track of all changes within. I really like the convenience that Terraform offers when working on cloud-based infrastructure.

## Terragrunt

I'm using Terragrunt on top of Terraform to handle environments. You can have different environments, each with it's own configuration without repeating yourself (DRY).

### tfenv and tgenv

With **tfenv** and **tgenv** I keep track of what version of Terraform and Terragrunt to work with. As I work on a Mac, I'm using *Brew* to install dependencies

`brew install tfenv tgenv`

`tfenv install && tgenv install`

# Lightweight Kubernetes - K3D on Docker

All you need for having Kubernetes on your local machine is Docker, [k3d](https://k3d.io/v5.4.4/#installation) and Kubectl to interact with.

## Disable Traefik for the sake of nginx

As I use nginx as my ingress controller, I needed to disable Traefik on K3D
`k3d cluster create -p "80:80@loadbalancer" --k3s-arg="--disable=traefik@server:0"`
This will also expose the Ingress on your localhost.

When your k3d backed Kubernetes is ready, you're also ready to deploy the stack using Terragrunt.

`cd environment/dev && terragrunt apply -auto-approve`

Your local Kubernetes based wordpress installation should now be available [here](http://localhost/wp-admin/install.php)

## Dashboard

Create a user token: `kubectl -n kube-dashboard create token admin-user`
The Dashboard should also be available on port 8080.