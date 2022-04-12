# he110_infra

## Подключение к ВМ через бастион

Для быстрого подлючения к виртуальной машине через бастион-хост можно использовать флаг утилиты `ssh` – Jumphost (`-J`)

```bash
▶ ssh -i ~/.ssh/appuser -J appuser@51.250.77.249 appuser@10.128.0.21
```

Для того, чтобы не вводить команду каждый раз целиком, можно преднастроить ssh-хосты. Для этого необходимо создать и отредактировать файл **~/.ssh/config**. Внесем туда следующие записи

```
Host otus.bastion
    HostName 51.250.77.249
    User appuser
    Port 22
    ForwardAgent yes
    IdentityFile ~/.ssh/appuser

Host otus.someinternalhost
    HostName 10.128.0.21
    User appuser
    Port 22
    ProxyCommand ssh -q -W %h:%p otus.bastion
```

После этого, для подключения к защищенной машине просто вводим:

```bash
▶ ssh otus.someinternalhost
```

## Адреса серверов

```
bastion_IP = 51.250.77.249
someinternalhost_IP = 10.128.0.21
testapp_IP = 51.250.4.186
testapp_port = 9292
```

## Создание инстанса reddit-app

```bash
yc compute instance create \
  --name reddit-app-1 \
  --hostname reddit-app-1 \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --zone ru-central1-a \
  --metadata-from-file user-data=./metadata.yml
```

## Подготовка загрузочного диска

Образ загрузочного диска готовится с помощью `Packer` на основании файла **packer/ubuntu16.json**

Для создания образа необходимо:

1. Переименовать файл **packer/variables.json.example** в **packer/variables.json**
2. Обновить значения переменных в файле **packer/variables.json**
3. Выполнить команду `cd packer && packer build ./ubuntu16.json`

> **Важно!** У вас должен быть сгенерированн ключ доступа служебной учетной записи Yandex Cloud. Путь до файла указывается в **packer/variables.json**


## Создание инфраструктуры

Подготовка инфраструктуры выполняется с помощью Terraform. Что бы запустить процесс создания, выполните:

1. Скопируйте файл **terraform/terraform.tfvars.example** в **terraform/terraform.tfvars**
2. Введите актуальные данные в файле **terraform/terraform.tfvars**
3. Откройте в терминате директорию **terraform** и выполнте команду `terraform apply --auto-approve`
