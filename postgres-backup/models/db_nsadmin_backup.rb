require 'dotenv/load'

SECRETS = YAML.load_file('./secrets.yml')

Model.new(:db_nsadmin_backup, "Back-up NSadmin database") do
  database PostgreSQL do |db|
    db.name               = ENV['POSTGRES_DATABASE']
    db.username           = ENV['POSTGRES_USER']
    db.password           = ENV['POSTGRES_PASSWORD']
    db.host               = 'db'
    db.port               = 5432
    db.additional_options = ['-xc', '-E=utf8']
  end

  store_with Local do |local|
    local.path = ENV['BACKUP_LOCATION']
    local.keep = Time.now - 60 * 60 * 24 * 30 # Remove all backups older than 1 month.
  end

  encrypt_with OpenSSL do |encryption|
    encryption.password_file = './password'
    encryption.base64        = true
    encryption.salt          = true
  end

  compress_with Gzip

  notify_by Slack do |slack|
    slack.on_success = true
    slack.on_warning = true
    slack.on_failure = true

    slack.webhook_url = SECRETS['slack']['webhook_url']
    slack.username = "Backup"
  end
end
