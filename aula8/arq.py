##No windows, baixar o 

##WAMP


## instalação do MySQL no debian 10

# Passo 0: Logar como root

Abrir o terminal e executar o comando: su -
senha: 4linux

atualizar os repositórios/cache através do comando : apt update

# Passo 1: Instalar o wget

apt install wget

# passo 2: Adicionar o MySQL na sua lista de repositórios

wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
apt install lsb-release
dpkg -i mysql-apt-config_0.8.13-1_all.deb

escolher OK na 3a opcao

# passo3: Atualizar a lista de repositórios e instalar o mysql

apt update 

apt install mysql-server

No meio da instalacao será solicitado uma senha para root: utilizar 4linux


# passo4: acessar o mysql 

systemctl restart mysql.service
mysql -u root -p

inserir a senha

# passo5: criar banco de dados 4linux
create database 4linux;

## instalacao do pip

apt update && apt install python3-pip

## instalar o driver de banco de dados do mysql para python pymysql 

pip3 install pymysql

