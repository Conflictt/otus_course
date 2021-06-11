lockfile=/tmp/localfile

if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then
    trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
    while true
    do
        # What to do
        ls -ld ${lockfile}
        sleep 1
    done
   rm -f "$lockfile"
   trap - INT TERM EXIT
else
   echo "Failed to acquire lockfile: $lockfile."
   echo "Held by $(cat $lockfile)"
fi

# IP адреса с наибольшим количеством запросов (20)
awk -F" " '{print $1}' access.log | sort | uniq -c | sort -nr | head -10

cat access.log | awk '{print $1}' | sort -rn | uniq | head -n 10

# Запрашиваемые url с наибольшим количеством запросов (20)
awk -F" " '{print $7}' access.log | sort | uniq -c | sort -nr | head -10

# Все ошибки
cat error.log | grep "$errd"

# Http коды возврата и их количество (20)
awk -F" " '{print $9}' access.log | sort | uniq -c | sort -nr
