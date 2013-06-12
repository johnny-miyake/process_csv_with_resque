redis_conf_path = Rails.root.join("config/redis", "#{Rails.env}.conf")
redis_conf = File.read(redis_conf_path)
port = /port.(\d+)/.match(redis_conf)[1]
host = "localhost"
Resque.redis = Redis.new(host: host, port: port)
