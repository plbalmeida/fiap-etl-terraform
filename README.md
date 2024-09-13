# ETL com AWS e Terraform

Repositório referente a parte 3 do hands-on de ETL com AWS da fase de Big Data da Pós Tech de Machine Learning Engineering da FIAP.

O objetivo desse exercício é provisionar com Terraform os recursos de um pipeline de dados na AWS.  

## Descrição Geral

Este projeto implementa um pipeline ETL que:

- Extrai dados de uma fonte (usando o pacote ipeadatapy).
- Transforma os dados conforme necessário.
- Carrega os dados transformados em um bucket S3.
- Utiliza AWS Glue para orquestrar os jobs ETL.
- Orquestra os jobs usando AWS Step Functions.
- Agenda a execução diária do pipeline usando AWS EventBridge.
- Gerencia a infraestrutura usando Terraform para garantir reprodutibilidade e controle de versão.

## Pré-requisitos

- Terraform instalado na máquina local.
- Conta AWS.

## Configuração

Certifique-se de que suas credenciais AWS estão configuradas corretamente:

```bash
aws configure
```

Ou configure o arquivo `~/.aws/credentials` com as chaves de acesso.

## Detalhes dos diretórios do repositório 

* **`iam/`**: Contém a configuração Terraform para criar a role IAM `fiap-etl-role` com a política `PowerUserAccess` e o trust relationship necessário.

* **`s3/`**: Provisiona o bucket S3 `fiap-etl` com os paths estruturados para armazenar os dados em diferentes estágios do pipeline.

* **`scripts/`**: Contém os scripts Python (`extract.py`, `transform.py`, `load.py`) utilizados pelos jobs do Glue.

* **`glue/`**: Configura os jobs do AWS Glue, definindo os parâmetros necessários e referenciando os scripts no S3.

* **`stepfunctions/`**: Define a máquina de estados `fiap-etl` no AWS Step Functions para orquestrar os jobs do Glue.

* **`eventbridge/`**: Configura a regra do EventBridge que agenda a execução diária do pipeline ETL.

## Provisionando recursos na AWS

Navegue até o diretório e aplique o Terraform:

```bash
cd <PATH>
terraform init
terraform plan
terraform apply
```

Para destruir os recursos provisionados:

```bash
cd <PATH>
terraform destroy
```

