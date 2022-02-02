# frozen_string_literal: true

require 'redis'

def run_worker(num_sets, redis_url)
  puts "[#{Process.pid}] worker spawn"
  loop do
    begin
      redis = Redis.new(url: redis_url)
      is_add = [true, false].sample
      set_number = rand(num_sets)
      value = rand(100_000_000)
      puts "[#{Process.pid}] is_add: #{is_add}, set: #{set_number}, value: #{value}"
      if is_add
        redis.sadd("set_#{set_number}", value)
      else
        redis.srem("set_#{set_number}", value)
      end
      sleep(rand(0..1.0))
    rescue Redis::TimeoutError
      puts "[#{Process.pid}] timeout"
    end
  end
end

num_workers = ARGV[0].to_i
num_sets = ARGV[1].to_i
redis_url = ARGV[2]

puts "going to spawn #{num_workers} workers"

num_workers.times do
  puts "[#{Process.pid}] spawning worker"
  Process.fork { run_worker(num_sets, redis_url) }
end

Process.waitall

puts 'all done'
