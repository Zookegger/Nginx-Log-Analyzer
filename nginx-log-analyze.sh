if [ -z $1 ]; then 
    echo "Usage: $0 <nginx-log-file-directory>"
    exit 1
fi
LOG=$1

echo "Top 5 IP addresses with the most request"

cat $LOG | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%-14s - %d requests\n", $2, $1}'

echo

echo "Top 5 most requested path"

cat $LOG | awk '{print "/api"$7}' | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%-40s - %d requests\n", $2, $1}'

echo

echo "Top 5 response status codes"

cat $LOG | awk '{if ($9 ~ /^[0-9]+$/) print $9}' | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

echo

echo "Top 5 user agents"

#awk -F is a custom delimiter. For every encounter of '', it counts as 1 field

cat $LOG | awk -F '"' '{print $6}' | sort | uniq -c | sort -nr | sed -E 's/^ *([0-9]+) (.*)/"\2"\t\1/' | head -n 5 | awk -F '"' '{printf "%-117s - %d requests\n", $2, $3}'
