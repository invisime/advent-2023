#!/usr/bin/ruby

require 'pry'

class GalaxyMap
	def initialize lines
		@height = lines.count
		@width = lines[0].length
		@galaxies = []
		lines.each_index do |row|
			line = lines[row]
			matches = (0...line.length).find_all {|i| line[i,1] == '#' }
			@galaxies += matches.map {|column| [row, column]}
		end
		@empty_rows = (0...@height).to_a - @galaxies.map(&:first)
		@empty_columns = (0...@width).to_a - @galaxies.map(&:last)
		chart_galaxies
	end

	def chart_galaxies expansion=2
		@expansion = expansion-1
		@pairs = {}
		(0...@galaxies.count).each do |a|
			(a+1...@galaxies.count).each do |b|
				distance = distance_between @galaxies[a], @galaxies[b]
				@pairs[[@galaxies[a], @galaxies[b]]] = distance
			end
		end
	end

	def distance_between pointA, pointB
		rowA, rowB = *([pointA[0], pointB[0]].sort)
		rowExpansion = @empty_rows.filter{|r| (rowA..rowB).cover? r}.count
		columnA, columnB = *([pointA[1], pointB[1]].sort)
		columnExpansion = @empty_columns.filter{|c| (columnA..columnB).cover? c}.count
		rowB - rowA + rowExpansion*@expansion +
			columnB - columnA + columnExpansion*@expansion
	end

	def sum_of_distances
		@pairs.values.sum
	end
end

# lines = IO.readlines('sample11.txt').map(&:strip)
lines = IO.readlines('input11.txt').map(&:strip)

galaxy_map = GalaxyMap.new lines
puts galaxy_map.sum_of_distances

galaxy_map.chart_galaxies 1000000
puts galaxy_map.sum_of_distances

binding.pry galaxy_map
