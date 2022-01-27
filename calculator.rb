# frozen_string_literal: true

require 'redis'

def run_calculator
  puts "[#{Process.pid}] calculator spawn"
  redis = Redis.new(url: 'redis://172.17.0.1:6379')
  loop do
    sets = []
    rand(2..10).times do
      sets << "set_#{rand(100)}"
    end
    puts "[#{Process.pid}] intersection of #{sets.join(',')}"
    redis.sinter(sets)
    sleep(rand(3..7))
  end
end

num_calculators = ARGV[0].to_i

puts "going to spawn #{num_calculators} calculators"

num_calculators.times do
  puts "[#{Process.pid}] spawning calculator"
  Process.fork { run_calculator }
end

Process.waitall

puts 'all done'
