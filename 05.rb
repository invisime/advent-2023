#!/usr/bin/ruby

require 'pry'

class MapRange
	def initialize
		@rangesToOffsets = {}
	end

	def addConfig config
		valueStart, keyStart, length = config.strip.split(/\s+/).map(&:to_i)
		@rangesToOffsets[(keyStart...keyStart+length)] = valueStart - keyStart
	end

	def mappedValueFor value
		foundRange = findRangeFor value
		!foundRange ? value : value + @rangesToOffsets[foundRange]
	end

	def findRangeFor value
		@rangesToOffsets.keys.each do |range|
			return range if range.cover? value
		end
		return nil
	end

	class << self
		MAP_NAMES = %w(seed-to-soil soil-to-fertilizer fertilizer-to-water
			water-to-light light-to-temperature temperature-to-humidity
			humidity-to-location)

		def configureAllMaps allLines
			@@allMaps, mapIndex, lastMap = {}, 0 , nil
			allLines[2..-1].each do |line|
				if line.start_with? MAP_NAMES[mapIndex]
					lastMap = @@allMaps[MAP_NAMES[mapIndex]] = MapRange.new
				elsif line.empty?
					mapIndex += 1
				else
					lastMap.addConfig line
				end
			end
			return @@allMaps
		end

		def findSeedLocations seeds
			locations = []
			seeds.each do |seed|
				number = seed
				MAP_NAMES.each do |mapName|
					number = @@allMaps[mapName].mappedValueFor number
				end
				locations.push number
			end
			locations
		end
	end
end

# lines = IO.readlines('sample05.txt').map(&:strip)
lines = IO.readlines('input05.txt').map(&:strip)

MapRange.configureAllMaps lines

seeds = lines[0].split(' ')[1..-1].map(&:to_i)
locations = MapRange.findSeedLocations seeds
puts locations.min

locations = []
seedRanges = []
(seeds.count/2).times do |i|
	start, length = seeds[i*2], seeds[i*2 + 1]
	seedRanges.push(start...start+length)
	locations += MapRange.findSeedLocations seedRanges[-1]
end
puts locations.min

binding.pry

#elapsed time: 1h45m
