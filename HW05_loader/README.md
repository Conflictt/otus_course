Домашняя работа

Попасть в систему без пароля несколькими способами

Во всех способах нужно также удалять строку 'console=ttyS0,115200n8'

Способ 1. 'init=/bin/sh'

![alt text](screenshots/1.bmp)

В конце строки начинающейся с linux16 добавляем init=/bin/sh и нажимаем сtrl-x для загрузки в систему

Далее нужно перемонтировать систему в Read-Write режим командой
- `mount -o remount,rw /`

Убедится можно создав файл и записав в него иформацию

![alt text](screenshots/3.bmp)


Способ 2. rd.break

В конце строки начинающейся с linux16 добавляем rd.break и нажимаем сtrl-x для загрузки в систему
После загрузки в систему попадаем в emergency mode. Чтобы попасть в корневую файловую систему и сменить пароль админа нужна выполнить следующие команды:

```
- mount -o remount,rw /sysroot
- chroot /sysroot
- passwd root
- touch /.autorelabel
```

![alt text](screenshots/5.bmp)

Способ 3. rw init=/sysroot/bin/sh

В конце строки начинающейся с linux16 заменяем ro на rw init=/sysroot/bin/sh нажимаем сtrl-x для загрузки в систему

![alt text](screenshots/6.bmp)

![alt text](screenshots/7.bmp)


Установить систему с LVM, после чего переименовать VG
