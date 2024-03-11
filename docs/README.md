<a id="top"></a>

<div align="center">

# Challenge DevOps: Infrastructure

> Deploys an infrastructure in a containerized cloud application.

This repository stores the code used to build the infrastructure needed to deploy the Aluraflix API using **Terraform** to provision resources and **Github Actions** to automate deployment.

<a>English</a> -
<a href="./README_pt-br.md">Portuguese</a>

</div>

<div align="center" >

![GitHub Actions Plan](https://img.shields.io/github/actions/workflow/status/jeff-pedro/challenge-devops-infra/terraform-plan.yml?event=pull_request&style=flat-square&logo=github-actions&label=plan)
![GitHub Actions Apply](https://img.shields.io/github/actions/workflow/status/jeff-pedro/challenge-devops-infra/terraform-apply.yml?branch=main&event=pull_request&style=flat-square&logo=github-actions&label=apply)
![Terraform Version](https://img.shields.io/badge/terraform-v1.7.1-blueviolet?logo=terraform)
![Release](https://img.shields.io/github/v/release/jeff-pedro/challenge-devops-infra?display_name=tag&include_prereleases&style=flat-square)

</div>

---

## Tecnologies

- **Terraform** as IaC
- **Github Actions** as CI/CD

## What will be built...

### Network

- **VPC** as a virtual network dedicated to the application
- **Subnets** across different availability zones
- **Internet Gateway** for Internet access
- **Route Tables** mapping network route traffic
- **Security groups** in service level access control

<div align="center" >
  <img src="/docs/img/vpc.svg"  alt="imagem da arquitetura da vpc" align="center"/>
</div>

### Computing

- **EC2 instances** generated via **Launch Template**
- **Autoscaling group** to manage server scalability
- **Load Balancer** as an interface that will redirect requests to a target group

<div align="center" >
  <img src="/docs/img/ec2.svg"  alt="imagem da arquitetura da ec2" align="center"/>
</div>

### Amazon ECS

- **Cluster** grouping infrastructure (autoscaling), services and other sharing configurations
- **Service** willl be manage the tasks
- **Tasks** is where the container of the application that will be run

<div align="center" >
  <img src="/docs/img/ecs.svg"  alt="imagem da arquitetura da ecs" align="center"/>
</div>

### Full architecture

<div align="center" >
  <img src="/docs/img/architecture-v1.svg"  alt="arquitetura da infraestrutura" align="center"/>
</div>

## Aluraflix API

- [challenge-devops-app](https://github.com/jeff-pedro/challenge-devops-app)

## Using the repository

1. Clone the repository

2. Configure the [secrets](https://docs.github.com/pt/actions/security-guides/using-secrets-in-github-actions) and environment variables on Github:

- **TF_CLOUD_ORGANIZATION**: organization in which the project is created in [Terraform Cloud](https://app.terraform.io/app).
- **TF_API_TOKEN**: token generated in [Terraform Cloud](https://app.terraform.io/app).
- **TF_WORKSPACE**: name of the workspace in [Terraform Cloud](https://app.terraform.io/app) where the implementation of resources will be executed.

<div align="center" >
  <img src="/docs/img/github.jpg" width="600" align="center"/>
</div>

3. Configure environment variables in [Terraform Cloud](https://app.terraform.io/app):

- **AWS_ACCESS_KEY_ID**: AWS account IAM access key ID
- **AWS_SECRET_ACCESS_KEY**: AWS account IAM secret access key ID (sensitive)

<div align="center" >
  <img src="/docs/img/terraform.jpg" width="600" align="center"/>
</div>

4. As the entire process is carried out via CI, to implement the infrastructure it is necessary to make a **Pull Request** of any change and perform the Merge

5. Another way is to directly access Github Actions and run the workflow in the dashboard

---

[Back to top](#top)
