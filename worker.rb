# frozen_string_literal: true

require 'redis'

def run_worker
  puts "[#{Process.pid}] worker spawn"
  redis = Redis.new(url: 'redis://172.17.0.1:6379')
  loop do
    is_add = [true, false].sample
    set_number = rand(100)
    value = rand(100_000_000)
    puts "[#{Process.pid}] is_add: #{is_add}, set: #{set_number}, value: #{value}"
    if is_add
      redis.sadd("set_#{set_number}", value)
    else
      redis.srem("set_#{set_number}", value)
    end
    sleep(rand(0..1.0))
  end
end

num_workers = ARGV[0].to_i

puts "going to spawn #{num_workers} workers"

num_workers.times do
  puts "[#{Process.pid}] spawning worker"
  Process.fork { run_worker }
end

Process.waitall

puts "all done"
