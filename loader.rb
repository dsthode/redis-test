# frozen_string_literal: true

require 'redis'
require 'benchmark'

num_sets = ARGV[0].to_i
redis_url = ARGV[1]

redis = Redis.new(url: redis_url)

puts "running for #{num_sets} sets"

num_sets.times do |i|
  (rand(1..10) * 10).times do
    redis.sadd("set_#{i}", Array.new(1_000) { rand(100_000_000) })
  end

  puts "#{i} done"
end
