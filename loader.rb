# frozen_string_literal: true

require 'redis'
require 'benchmark'

redis = Redis.new(url: 'redis://172.17.0.1:6379')

num_sets = ARGV[0].to_i

puts "running for #{num_sets} sets"

num_sets.times do |i|
  (rand(1..10) * 1_000).times do
    redis.sadd("set_#{i}", Array.new(1_000) { rand(100_000_000) })
  end

  puts "#{i} done"
end
