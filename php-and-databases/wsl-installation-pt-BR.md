# Instalação docker no WSL2

**Artigo de referência:** 

https://github.com/codeedu/wsl2-docker-quickstart#docker-desktop-com-wsl2

**Vantagens dessa abordagem:**

- Por todo ambiente do docker estar no linux o desempenho é naturalmente maior
- O Docker Desktop cria ambientes virtuais próprios para gestão dos containers e por isso ocupa mais espaço em disco e memória mesmo quando nenhum container está ativo
- Por não mapear os volumes do docker para o windows diretamente, não há gargalo de rede e disco, o docker entende como arquivo nativo o que tem um impacto positivo no desempenho de mais de 3000%
  - No nosso caso de estudo, uma requisitção simples de listagem de dados no docker nestas configurações é executada em questão de 30-70ms
  - Já no docker desktop ou com volume mapeado para unidades Windows, a mesma requisição é executada em 1,9s - 3,5s

**Desvantagens dessa abordagem:**

- Ao iniciar o windows e o WSL2, o docker não inicia automaticamente, sendo necessário iniciar manualmente
- Por não ter interface gráfica do Docker Desktop é necessário fazer o uso da linha de comando do ubuntu para manipular os containers
  - O que pode ser traduzido como vantagem para estar sempre em contato com a linha de comando e com o docker exercitando o conhecimento

# Preparação de ambiente

- Habilitar o WSL2
  - Executar o comando no Powershell:
    - `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
- Habilitar a virtualização
    - Executar o comando no Powershell:
        - `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
- Definir o WSL2 como padrão
  - Executar o comando no Powershell:
    - `wsl --set-default-version 2`
- Instalar o ubuntu na loja da microsoft
  - Executar o ubuntu
  - Criar um usuário e senha para o ubuntu
- Configurar o .wslconfig (se necessário) para aumentar recursos de máquina (na pasta de usuário do windows)
  - `.wslconfig`
  - Inserir o conteúdo abaixo:
    - ```
      [wsl2]
      memory=4GB # Limits VM memory in WSL 2 to 4 GB
      processors=2 # Makes the WSL 2 VM use two virtual processors
      swap=2GB
      ```

# Instalação do Docker

- Abrir o ubunto e executar os comandos abaixo:

``` bash

# Atualizar o sistema
sudo apt update && sudo apt upgrade
sudo apt remove -y docker docker-engine docker.io containerd runc
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Adicionar repositório do docker:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar o docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

# Permissão de usuários
sudo usermod -aG docker $USER

# Alternar para modo de rede legacy
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy

# Inicializar o docker 
sudo service docker stop
sudo service docker start

# conferir se rodou
docker ps

```

## Configuração adicional

- Adicionar o DNS do google para o docker:

``` bash
# Criar arquivo de configuração
sudo nano /etc/docker/daemon.json

# Inserir o conteúdo abaixo:
{
  "dns": ["8.8.8.8"]
}

# Salvar o arquivo
# Reiniciar o docker
sudo service docker restart
```

# Entendendo conceitos e estrutura de pastas

## Neste tutorial a estrutura de pastas do docker está refletida em:
- /dockers - Pasta raiz de configuração dos dockers
- /dockers/bins - Pasta de binários dos dockers
- /dockers/config - Pasta de configuração dos dockers customizados
- /dockers/config/mysql57-lamp - Stack Mysql 5.7 + PHP 7.4 + PHP 8.0 + Apache 2.4 + PhpMyAdmin
- /dockers/config/docker-start.sh - Facilitador para restart do docker 

## Cada Docker composer tem uma estrutura composta de (exemplo mysql57-lamp)
- /config/mysql - Override de configurações do Mysql
- /config/php - Override de configurações do PHP	
- /config/ssl - Override de configurações SSL
- /mysql57 - Volume de dados do mysql separado entre as categorias data, initdb e logs
- /www - Pasta de container de arquivos de sites

# Instalação dos containers docker

Uma vez que rodou o comando `docker ps` sem erros, podemos instalar os containers docker, e para tanto seguiremos as etapas abaixo:

- Criação de pasta na raiz do Ubuntu e configurar as permissões 
  - `sudo mkdir valkhan`
  - `sudo chown -R valkhan:valkhan` Alterar o nome valkhan, para seu usuário ubuntu
  - `sudo chmod -R 2777 valkhan`
- Copiar a pasta "dockers" para dentro da pasta criada
  - No explorer do windows, procurar debaixo do linux a pasta "ubuntu"
  - Ao acessar a pasta ubuntu você terá acesso direto ao sistema de arquivos linux
  - Agora basta copiar a pasta "dockers" para dentro da pasta criada anteriormente
- Acessar a pasta dockers e executar o comando abaixo para instalar os containers
  - `cd /valkhan/dockers/config/mysql57-lamp`
  - `docker-compose up -d`
  - Conferir se não houve erro na instalação, se acusar erro de utilização de portas já em uso, não se preocupe porque temos duas versões de PHP rodando na mesma porta e apenas uma delas estará rodando por vez.
  - Acessar o phpmyadmin na máquina host (localhost:8080)
    - Se acessar o phpmyadmin significa que foi instalado com sucesso o docker lamp
    - Vamos configurar o usuário do banco de dados para permissão total:
      - No phpmyadmin, acessar a aba "contas de utilizador"
      - Editar privilégios do usuário docker
      - Marcar todas as opções de permissão e salvar
      - Alterar para aba Base de Dados e editar os privilégios do usuário docker
      - Marcar todas as opções de permissão e salvar
  - Agora vamos configurar o MySql para rodar com o ONLY_FULL_GROUP_BY desabilitado
    - Acessar a pasta: `/valkhan/dockers/config/mysql57-lamp/config/mysql`
    - Executar o comando `docker cp /valkhan/dockers/config/mysql57-lamp/config/mysql/mysqld.cnf mysql57-database:/etc/mysql/conf.d/mysqld.cnf`
    - Garantir que o arquivo esteja com permissão 664
    - Reiniciar o container do mysql: `docker restart mysql57-database`

# Configuração de sites e boas práticas

## Configuração de novo projeto codeigniter 4

- Criar uma pasta para cada site dentro da pasta `/valkhan/dockers/config/mysql57-lamp/www`, mapeie este caminho no acesso rápido do explorer do windows
- Ao subir um projeto padrão do Codeigniter 4 é necessário ajustar as permissões de pasta, considerando que já esteja na pasta www do projeto, executar os comandos abaixo:
  - `sudo chmod -R 2777 nome-do-portal/writable`
  - `sudo chown -R www-data:valkhan nome-do-portal` - alterar valkhan para seu nome de usuário
- O arquivo env deve configurar o banco de dados como "database" que é o nome do serviço do Mysql dentro deste docker compose.
- Para rodar o composer correto para a versão de php alvo, exemplo PHP 7.4:
  - `docker exec -it mysql57-php74 bash` - Acessar o shell do container
  - Navegar à pasta do projeto e executar o comando:
  - `composer install --no-dev` - Instalar as dependências do projeto

## Dicas

- Sempre que reiniciar o computador ou que o docker não esteja acessível:
  - Abrir o ubuntu
  - Acessar a pasta `/valkhan/dockers/config`
  - Executar o comando `./docker-start.sh`
    - Este comando além de inicializar ele primeiro para o serviço do docker que por vezes aparece como rodando mas os comandos `docker ps` não funcionam.
    - Uma vez que o docker está em execução pode fechar o terminal do ubuntu que ele continuará funcionando pois o WSL2 ainda está em execução e retornará ao estado atual quando for aberto novamente.

- Comandos úteis:
  - `docker ps` - Lista os containers em execução
  - `docker exec -it [nome-do-container] bash` - Acessa o shell do container
- Para trocar a versão do PHP, exemplo de PHP 7.4 para PHP 8.0:
  - `docker stop mysql57-php74`
  - `docker start mysql57-php80`
- Para inicializar o phpmyadmin:
  - `docker start mysql57-phpmyadmin`