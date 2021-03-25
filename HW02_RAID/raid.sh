#!/bin/bash

#Занулить суперблоки
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}

#Создать рейд 5 из 5 дисков
mdadm --create --verbose /dev/md0 -l 5 -n 5 /dev/sd{b,c,d,e,f}

#Создать папку для файла конфигурации mdadm
mkdir /etc/mdadm

#Добавление информации о массиве в конфигурационный файл
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

#Создать gpt раздел на рейд массиве
parted -s /dev/md0 mklabel gpt

#Создать разделы
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

#Создать файловые системы на разделах
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done

#Создание каталогов для монтирования
mkdir -p /raid/part{1,2,3,4,5}

#Монитрование разделов
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done

#Добавление информации о устройствах в fstab
cat /etc/mtab | grep raid >> /etc/fstab
