Домашняя работа ZFS

Лог выполнения команд: https://github.com/Conflictt/Otus_course/blob/main/HW04_ZFS/cli_log

Установка zfs
- `yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm`
- `gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux`
- `yum-config-manager --enable zfs-kmod`
- `yum-config-manager --disable zfs`
- `yum install -y zfs`
- `sbin/modprobe zfs`

Определение алгоритма с наилучшим сжатием
`zfs get compressratio,compression /zfs_001/zfs_fs_00{1..4}`
 ```
 NAME                PROPERTY       VALUE     SOURCE
    zfs_001/zfs_fs_001  compressratio  1.37x     -
    zfs_001/zfs_fs_001  compression    lzjb      local
    zfs_001/zfs_fs_002  compressratio  2.21x     -
    zfs_001/zfs_fs_002  compression    gzip      local
    zfs_001/zfs_fs_003  compressratio  1.05x     -
    zfs_001/zfs_fs_003  compression    zle       local
    zfs_001/zfs_fs_004  compressratio  1.63x     -
    zfs_001/zfs_fs_004  compression    lz4       local
 ```

Лучше всех справился gzip

Определить настройки pool
```
zfs get all | grep otus | grep ' available \| type \| recordsize \| compression \| checksum'
otus                type                  filesystem             -
otus                available             350M                   -
otus                recordsize            128K                   local
otus                checksum              sha256                 local
otus                compression           zle                    local
otus/hometask2      type                  filesystem             -
otus/hometask2      available             350M                   -
otus/hometask2      recordsize            128K                   inherited from otus
otus/hometask2      checksum              sha256                 inherited from otus
otus/hometask2      compression           zle                    inherited from otus
```

Найти сообщение от преподавателей:
- результат https://github.com/sindresorhus/awesome
