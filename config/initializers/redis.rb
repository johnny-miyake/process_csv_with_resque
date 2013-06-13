require "redis"
redis_conf_path = Rails.root.join("config/redis", "#{Rails.env}.conf")
redis_conf = File.read(redis_conf_path)
port = /port.(\d+)/.match(redis_conf)[1]
host = "localhost"
`redis-server #{redis_conf_path}`
res = `ps aux | grep redis-server`
# You can do below if you use Redis directly in your application.
# $redis = Redis.new(host: host, port: port)
