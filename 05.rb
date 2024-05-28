#!/usr/bin/ruby
class Range
	# enable sorting of ranges in an array
  def <=>(other)
    [min, max] <=> [other.min, other.max]
  end

	EMPTY_RANGE = (-Float::INFINITY...-Float::INFINITY)
  def empty?
  	self == EMPTY_RANGE
  end

	# true if self is left of and overlaps other
	def leftOverlap?(other)
		cover?(other.min) && other.cover?(max)
	end

	# true if self is right of and overlaps other
	def rightOverlap?(other)
		other.leftOverlap?(self)
	end

  def &(other)
		a, b = self, other
		return a if b.cover? a
		return b if a.cover? b
		return (b.min..a.max) if a.leftOverlap? b
		return (a.min..b.max) if a.rightOverlap? b
		return EMPTY_RANGE if b.max < a.min || a.max < b.min
  end

  def -(other)
		a, b = self, other
		return [] if b.cover? a
		return [self] if b.max < a.min || a.max < b.min
		return [(a.min..b.min-1)] if a.leftOverlap? b
		return [(b.max+1..a.max)] if a.rightOverlap? b
		return [(a.min..b.min-1),(b.max+1..a.max)] if a.cover? b
  end
end

class MapRange
	def initialize
		@rangesToOffsets = {}
	end

	def addConfig config
		valueStart, keyStart, length = config.strip.split(/\s+/).map(&:to_i)
		@rangesToOffsets[(keyStart..keyStart+length-1)] = valueStart - keyStart
	end

	def rangesReachableFrom initialRanges
		reachableRanges = []
		initialRanges.each do |initialRange|
			reachedRanges = [initialRange]
			@rangesToOffsets.each do |map, offset|
				intersection = initialRange & map
				next if intersection.empty?
				reachedRanges.map!{|r| r - intersection}.flatten!
				reachedRanges.push(intersection.min+offset..intersection.max+offset)
			end
			reachableRanges = (reachableRanges + reachedRanges).sort
		end
		reachableRanges
	end

	def self.configureMapsFromInput allLines
		allMaps = []
		allLines[1..-1].each do |line|
			next if line.empty?
			if line.end_with? ':'
				allMaps.push MapRange.new
			else
				allMaps[-1].addConfig line
			end
		end
		allMaps
	end
end

# lines = IO.readlines('sample05.txt').map(&:strip)
lines = IO.readlines('input05.txt').map(&:strip)

seeds = lines[0].split(' ')[1..-1].map(&:to_i)
maps = MapRange.configureMapsFromInput lines

seedRanges1 = seeds.map{|s|(s..s)}.sort
reachableRanges = seedRanges1
maps.each do |map|
	reachableRanges = map.rangesReachableFrom reachableRanges
end
puts reachableRanges[0].min

seedRanges2 = []
(seeds.count/2).times do |i|
	start, length = seeds[i*2], seeds[i*2 + 1]
	seedRanges2.push(start..start+length-1)
end
reachableRanges = seedRanges2.sort
maps.each do |map|
	reachableRanges = map.rangesReachableFrom reachableRanges
end
puts reachableRanges[0].min
