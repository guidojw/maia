# Numbers of days you want to keep copies of your databases
KEEP=30

# String to append to the name of the backup files
DATE=$(date +%Y.%m.%d.%H.%M.%S)

echo "Dumping $1 to $BACKUP_LOCATION/$1/$DATE/$1.tar.enc"
export PGPASSWORD=$POSTGRES_PASSWORD
mkdir -p "$BACKUP_LOCATION"/"$1"/"$DATE"
pg_dump -Ft --username="$POSTGRES_USER" -h db "$POSTGRES_DATABASE" | gzip | openssl aes-256-cbc -base64 -md sha256 \
  -pass file:password -salt \
  -out "$BACKUP_LOCATION"/"$1"/"$DATE"/"$1".tar.enc

find "$BACKUP_LOCATION" -type f -prune -mtime \
  +$KEEP -exec rm -drf {} \;

bash notifiers/discord.sh "$1"
