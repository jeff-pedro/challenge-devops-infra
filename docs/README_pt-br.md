<a id="top"></a>
<div align="center">

  # Challenge DevOps: Infraestrutura

  > Implementa a infraestrutura de um aplicativo conteinerizado em nuvem.
  
  Este repositório armazena o código usado na construção da infraestrutura necessária para implantar a API Aluraflix usando **Terraform** para provisionar os recursos e **Github Actions** para automatizar o deploy.

  <a>Potuguese</a> -
  <a href="./README.md">English</a>

</div>

<div align="center" >

  ![Plan](https://img.shields.io/github/actions/workflow/status/jeff-pedro/challenge-devops-infra/terraform-plan.yml?branch=main&style=flat-square&label=plan)
  ![Apply](https://img.shields.io/github/actions/workflow/status/jeff-pedro/challenge-devops-infra/terraform-apply.yml?branch=main&style=flat-square&label=apply)
  ![Terraform Version](https://img.shields.io/badge/terraform-v1.7.1-blueviolet?logo=terraform)
  ![Release](https://img.shields.io/github/v/release/jeff-pedro/challenge-devops-infra?display_name=tag&include_prereleases&style=flat-square)
 
</div>

---

## Tecnologias
- **Terraform** como IaC
- **Github Actions** no CI/CD


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

### Computação
- **Instâncias EC2** geradas via **Launch Template**
- **Auto-scaling Group** para gerenciar a escalabilidade dos servidores
- **Load Balancer** como interface que irá direcionar as requisições a um grupo alvo (target group)

<div align="center" >
  <img src="/docs/img/ec2.svg"  alt="imagem da arquitetura da ec2" align="center"/>
</div>

### Amazon ECS
- **Cluster** agrupando a infraestrutura (auto-scaling), serviços entre outras configurações 
- **Service** gerenciando as tarefas
- **Tasks** é onde está configurado o container da aplicação que será executada

<div align="center" >
  <img src="/docs/img/ecs.svg"  alt="imagem da arquitetura da ecs" align="center"/>
</div>

### Arquitetura completa
<div align="center" >
  <img src="/docs/img/architecture.svg"  alt="arquitetura da infraestrutura" align="center"/>
</div>


## Aluraflix API
- [challenge-devops-app](https://github.com/jeff-pedro/challenge-devops-app)


## Usando o repositório

1. Clonar o repositório

2. Configurar as [secrets](https://docs.github.com/pt/actions/security-guides/using-secrets-in-github-actions) e variáveis de ambiente no Github:
- **TF_CLOUD_ORGANIZATION**: organização que o projeto está criado no [Terraform Cloud](https://app.terraform.io/app)
- **TF_API_TOKEN**: token gerado no [Terraform Cloud](https://app.terraform.io/app)
- **TF_WORKSPACE**: nome da workspace no [Terraform Cloud](https://app.terraform.io/app) onde será executado a implemtação dos recursos

<div align="center" >
  <img src="/docs/img/github.jpg" width="400" align="center"/>
</div>

3. Configurar variáveis de ambiente (env) no [Terraform Cloud](https://app.terraform.io/app):
- **AWS_ACCESS_KEY_ID**: IAM Access Key Id da conta da AWS
- **AWS_SECRET_ACCESS_KEY**: IAM Secret Access Key Id da conta da AWS (sensitive)

<div align="center" >
  <img src="/docs/img/terraform.jpg" width="400" align="center"/>
</div>

4. Como todo o processo é realizado via CI, para realizar o deploy da infraestrutura é necessário realizar um **Pull Request** de alguma altereção e realizar o Merge

5. Outra forma é acessar diretamente no Github Actions e executar o workflow no painel


---
[Voltar ao topo da página](#top)
