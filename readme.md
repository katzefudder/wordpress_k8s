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

As I use nginx as my ingress controller, I needed to disable Traefik on K3D.
The cluster's load balancer will be available via ports 80 and 443
`k3d cluster create -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-arg="--disable=traefik@server:0"`

For the sake of having some ears and eyes for what's going on there on our cluster, we need some monitoring:

Install [Kube Prometheus Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) for cluster monitoring.
`helm install -n monitoring -f terraform/modules/monitoring/config/monitoring.yaml kube-prometheus-stack  prometheus-community/kube-prometheus-stack`

When your k3d backed Kubernetes is ready, you're also ready to deploy the stack using Terragrunt.

`cd environment/dev && terragrunt apply -auto-approve`

# Services

To make usage of the ingress, I added the following `/etc/hosts`

```
127.0.0.1 grafana.localhost
127.0.0.1 prometheus.localhost
127.0.0.1 dashboard.localhost
127.0.0.1 wordpress.localhost
```

## some monitoring stuff

[http://prometheus.localhost](http://prometheus.localhost)
[http://grafana.localhost](http://grafana.localhost)

## Kubernetes Dashboard

[http://dashboard.localhost](http://dashboard.localhost)

Create a user token: `kubectl -n kube-dashboard create token admin-user`


## Wordpress

[http://wordpress.localhost](http://wordpress.localhost)

Your local Kubernetes based wordpress installation should now be available [here](http://wordpress.localhost)
