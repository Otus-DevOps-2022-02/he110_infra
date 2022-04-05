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
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/id_rsa.pub \
  --zone ru-central1-a \
  --metadata-from-file user-data=./metadata.yaml
```
