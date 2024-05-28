#!/usr/bin/ruby

class Race
	def initialize duration, record
		@t, @r = duration, record
	end

	def min
		((@t - Math.sqrt(@t**2-4*@r))/2 + 1).floor
	end

	def max
		((@t + Math.sqrt(@t**2-4*@r))/2 - 1).ceil
	end

	def ways
		(min..max).count
	end
end

# lines = IO.readlines('sample06.txt').map(&:strip)
lines = IO.readlines('input06.txt').map(&:strip)

times, distances = lines.map{|line| line.split[1..-1].map(&:to_i)}
races = times.count.times.to_a.map{|i| Race.new times[i], distances[i]}
puts races.map(&:ways).reduce(1,:*)

time, distance = lines.map{|line| line.split[1..-1].join.to_i}
race = Race.new time, distance
puts race.ways
