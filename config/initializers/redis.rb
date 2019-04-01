yml = YAML.load_file(File.join(Rails.root, "config", "redis.yml"))

$redis = Redis::Namespace.new("redis", :redis => Redis.new)
