# 🚀 API Flask com Deploy Automatizado na AWS (AppRunner + RDS)

Este projeto demonstra uma pipeline de CI/CD completa para uma API Python (Flask) conteinerizada.

A infraestrutura é provisionada na AWS usando Terraform, e o pipeline de build e deploy é orquestrado pelo GitHub Actions, utilizando OIDC para autenticação segura (sem chaves de acesso estáticas).

O projeto é dividido em duas fases principais de infraestrutura (Bootstrap e Main) para gerenciar corretamente o estado do Terraform e as dependências de autenticação.

## 🛠️ Arquitetura e Serviços Utilizados

  * **Aplicação:**

      * **Python (Flask):** A API simples que se conecta a um banco de dados.
      * **Docker:** A API é conteinerizada para portabilidade.

  * **Infraestrutura como Código (IaC):**

      * **Terraform:** Provisiona toda a infraestrutura da AWS.

  * **CI/CD:**

      * **GitHub Actions:** Orquestra o build, push e deploy.

  * **Serviços AWS:**

      * **AWS AppRunner:** Serviço PaaS que executa o contêiner da API, gerenciando escalabilidade e load balancing.
      * **AWS RDS (MySQL):** Banco de dados relacional gerenciado.
      * **AWS ECR (Elastic Container Registry):** Armazena a imagem Docker da API.
      * **AWS S3:** Armazena de forma segura o backend (`.tfstate`) do Terraform.
      * **AWS VPC (Virtual Private Cloud):** Rede privada isolada onde o RDS e o AppRunner residem.
          * *Sub-redes, Grupos de Segurança, DB Subnet Group, VPC Connector.*
      * **AWS IAM (Identity and Access Management):**
          * **Provedor OIDC:** Para autenticação segura do GitHub Actions (sem chaves).
          * **Role para o Pipeline:** Permissão para o GitHub Actions criar a infra (S3, ECR, AppRunner, RDS).
          * **Role para o AppRunner:** Permissão para o serviço AppRunner puxar a imagem do ECR.

## 📁 Estrutura do Projeto

A infraestrutura como código (IaC) está dividida para gerenciar o "paradoxo do ovo e a galinha" (o backend S3 precisa existir *antes* de ser usado).

  * `flask/iac/bootstrap/`: **Fase 1 (Manual)**.

      * **Propósito:** Criar os recursos fundamentais que o pipeline de CI/CD precisa para *rodar*.
      * **Recursos:** Bucket S3 (para o .tfstate), Provedor OIDC e as Roles IAM.
      * **Execução:** Deve ser executado **uma vez manualmente** da sua máquina local.

  * `flask/iac/main/`: **Fase 2 (Automatizada)**.

      * **Propósito:** Criar a infraestrutura da aplicação.
      * **Recursos:** VPC, Sub-redes, Security Groups, RDS (MySQL) e o AppRunner.
      * **Execução:** Executado **automaticamente pelo pipeline** do GitHub Actions.

  * `.github/workflows/`:

      * Contém o pipeline de CI/CD que executa a Fase 2.

## 🏁 Guia de Deploy

Siga estes 3 passos para subir o projeto.

### Pré-requisitos

1.  Uma conta AWS.
2.  Terraform CLI instalado localmente.
3.  AWS CLI instalado e configurado localmente (com um perfil de admin).
4.  Um "fork" deste repositório no seu GitHub.

-----

### Passo 1: Executar o Bootstrap (Manual)

Esta etapa cria os alicerces (S3, ECR, Roles) e só precisa ser feita uma vez.

1. Apos realizar o fork, clone o projeto:

    ```bash
    git clone <link_repo_forkado>
    ```

2.  Navegue até a pasta `bootstrap`:

    ```bash
    cd flask/iac/bootstrap
    ```

3.  Crie um arquivo `env.tfvars` com base nos seus dados. (Este arquivo **não deve** ser enviado ao Git).

    **`flask/iac/bootstrap/env.tfvars`**

    ```hcl
    aws_profile   = "" 
    aws_region    = "" 
    api_name      = "flask-api"
    oidc_provider = "token.actions.githubusercontent.com"
    oidc_client   = "sts.amazonaws.com"
    ```

3.  Configure suas variáveis de ambiente locais para que o Terraform possa se autenticar:

    ```bash
    export AWS_PROFILE="<seu_perfil>"
    export AWS_REGION="<sua_regiao>"
    ```

4.  Execute o Terraform:

    ```bash
    terraform init
    terraform apply -var-file=env.tfvars -auto-approve
    ```

5.  Ao final, o Terraform exibirá os `outputs`. **Copie os valores** de `pipeline_role_arn`, `ecr_repository_url` e `tfstate_bucket_name`. Você precisará deles no próximo passo.

-----

### Passo 2: Configurar os Segredos do GitHub

Vá até o seu *fork* do repositório no GitHub e navegue até:
`Settings > Secrets and variables > Actions`

Crie os seguintes **Secrets** (para dados sensíveis):

  * `PIPELINE_ROLE_ARN`: Cole o ARN da role que o `bootstrap` gerou (ex: `arn:aws:iam::1234567898:role/github-actions-pipeline-role`).
  * `AWS_REGION`: A região que você usou (ex: `us-east-1`).
  * `DB_USER`: O nome de usuário que você deseja para o RDS (ex: `user`).
  * `DB_PASS`: Uma senha segura para o RDS (ex: `SenhaSuperSegura123`).

Crie as seguintes **Variables** (para dados não-sensíveis):

  * `BUCKET_TFSTATE`: O nome do bucket S3 que o `bootstrap` criou (ex: `flask-api-tfstate-bucket-xxxx`).
  * `ECR_REPOSITORY_URL`: O URL do ECR que o `bootstrap` criou (ex: `009160076203.dkr.ecr.us-west-2.amazonaws.com/flask-api-ecr`).
  * `DB_NAME`: O nome do banco de dados (ex: `db`).
  * `API_NAME`: O nome da sua aplicação (ex: `flask-api`).
  * `API_PORT`: A porta que o Flask escuta (ex: `5000`).

-----

### Passo 3: Executar o Pipeline de CI/CD

Com o `bootstrap` executado e os segredos configurados, você está pronto.

1.  Certifique-se de que o seu código `flask/iac/main/` e o `.github/workflows/ci-cd.yml` estão corretos.

2.  Envie suas alterações para a branch `main`:

    ```bash
    git push origin main
    ```

3.  Vá até a aba "Actions" do seu repositório. O workflow será iniciado automaticamente.

**O que o pipeline fará:**

1.  **Configure AWS credentials:** Assume a role do pipeline (`PIPELINE_ROLE_ARN`) usando OIDC.
2.  **Login to Amazon ECR:** Autentica no ECR.
3.  **Build, tag, and push...:** Faz o build da sua imagem Docker e a envia para o ECR.
4.  **Run terraform init:** Inicializa o Terraform da pasta `flask/iac/main`, configurando o backend para usar o S3 que o `bootstrap` criou.
5.  **Run terraform apply:** Provisiona a VPC, RDS, AppRunner e todos os outros recursos da aplicação, injetando a `DATABASE_URI` (com o usuário e senha secretos) como uma variável de ambiente no AppRunner.

Ao final, seu serviço AppRunner estará ativo e respondendo na URL de serviço padrão.

## 🐳 Desenvolvimento Local (Opcional)

Para testar a API localmente com o `docker-compose`:

1.  Altere as variáveis de ambiente (portas, usuário/senha do DB local) no `docker-compose.yaml`.
2.  Execute:
    ```bash
    cd flask/
    docker-compose up -d --build
    ```