curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"embeds": [{"title": "'"$1"' successful", "description": "'"$1"' has been executed successfully!", "color": 65313}]}' \
  $DISCORD_WEBHOOK_URL
