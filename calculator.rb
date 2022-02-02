# frozen_string_literal: true

require 'redis'

def run_calculator(num_sets, redis_url)
  puts "[#{Process.pid}] calculator spawn"
  loop do
    begin
      redis = Redis.new(url: redis_url)
      sets = []
      rand(2..10).times do
        sets << "set_#{rand(num_sets)}"
      end
      puts "[#{Process.pid}] intersection of #{sets.join(',')}"
      redis.sinter(sets)
      sleep(rand(3..7))
    rescue Redis::TimeoutError
      puts "[#{Process.pid}] timeout"
    end
  end
end

num_calculators = ARGV[0].to_i
num_sets = ARGV[1].to_i
redis_url = ARGV[2]

puts "going to spawn #{num_calculators} calculators"

num_calculators.times do
  puts "[#{Process.pid}] spawning calculator"
  Process.fork { run_calculator(num_sets, redis_url) }
end

Process.waitall

puts 'all done'
