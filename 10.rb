#!/usr/bin/ruby

require 'pry'

class String

	NORTH_CONNECTORS = %w(| L J)
	SOUTH_CONNECTORS = %w(| 7 F)
	EAST_CONNECTORS  = %w(- L F)
	WEST_CONNECTORS  = %w(- 7 J)

	def northy?
		NORTH_CONNECTORS.include? self
	end
	def southy?
		SOUTH_CONNECTORS.include? self
	end
	def easty?
		EAST_CONNECTORS.include? self
	end
	def westy?
		WEST_CONNECTORS.include? self
	end
end

class PipeLoop

	def initialize input
		@sketch = []
		@start = nil
		input.each do |line|
			startingColumn = line.index 'S'
			@start = [@sketch.count, startingColumn] unless startingColumn.nil?
			@sketch.push line.chars
		end
		@height = @sketch.count
		@width = @sketch[0].count
		walk_pipes
		@inside = expand_area @inside
		@outside = expand_area @outside
	end

	def in_bounds? row, column
		row >= 0 && column >= 0 && row < @height && column < @width
	end

	def symbol_at row, column
		return '.' unless in_bounds? row, column
		@sketch[row][column]
	end

	def stepsToFarthestPoint
		@pipes.count / 2
	end

	def enclosedTileCount
		@inside.count
	end

	def pretty_print
		lines = []
		(0...@height).each do |row|
			line = ""
			(0...@width).each do |column|
				if @pipes.include? [row, column]
					line += symbol_at row, column
				elsif @outside.include? [row, column]
					line += 'O'
				elsif @inside.include? [row, column]
					line += 'I'
				else
					line += '!'
				end
			end
			lines.push line
		end
		lines.join "\n"
	end

	private
	def walk_pipes
		@pipes, rights, lefts, cursors = [@start], [], [], []
		north, south, east, west = [@start.first-1, @start.last], [@start.first+1,
			@start.last], [@start.first, @start.last+1], [@start.first, @start.last-1]
		cursors.push [:south, north] if symbol_at(*north).southy?
		cursors.push [:north, south] if symbol_at(*south).northy?
		cursors.push [:west, east] if symbol_at(*east).westy?
		cursors.push [:east, west] if symbol_at(*west).easty?
		raise ArgumentError.new("Invalid starting position") unless cursors.count == 2
		origin = cursors.first.first
		cursor = cursors.first.last
		until cursor == @start
			@pipes.push cursor.clone
			pipe = symbol_at(*cursor)
			if origin != :north && pipe.northy?
				rights.push [cursor.first, cursor.last+1]
				lefts.push [cursor.first, cursor.last-1]
				cursor[0] -= 1
				origin = :south
				rights.push [cursor.first, cursor.last+1]
				lefts.push [cursor.first, cursor.last-1]
			elsif origin != :south && pipe.southy?
				rights.push [cursor.first, cursor.last-1]
				lefts.push [cursor.first, cursor.last+1]
				cursor[0] += 1
				origin = :north
				rights.push [cursor.first, cursor.last-1]
				lefts.push [cursor.first, cursor.last+1]
			elsif origin != :east && pipe.easty?
				rights.push [cursor.first+1, cursor.last]
				lefts.push [cursor.first-1, cursor.last]
				cursor[1] += 1
				origin = :west
				rights.push [cursor.first+1, cursor.last]
				lefts.push [cursor.first-1, cursor.last]
			elsif origin != :west && pipe.westy?
				rights.push [cursor.first-1, cursor.last]
				lefts.push [cursor.first+1, cursor.last]
				cursor[1] -= 1
				origin = :east
				rights.push [cursor.first-1, cursor.last]
				lefts.push [cursor.first+1, cursor.last]
			end
		end
		rights = rights.uniq - @pipes
		lefts = lefts.uniq - @pipes
		if rights.flatten.any?(&:zero?)
			@inside, @outside = lefts, rights
		elsif lefts.flatten.any?(&:zero?)
			@inside, @outside = rights, lefts
		else
			raise ArgumentError.new "Edge of map not found."
		end
		@inside.filter!{|coords| in_bounds? *coords }
		@outside.filter!{|coords| in_bounds? *coords }
	end

	def expand_area tiles
		i = 0
		while i < tiles.count
			tile = tiles[i]
			neighbors = [[tile.first-1, tile.last],[tile.first+1, tile.last],
				[tile.first, tile.last+1],[tile.first, tile.last-1]]
				.filter{|c| in_bounds?(*c) }
			tiles += (neighbors - tiles - @pipes)
			i += 1
		end
		tiles
	end
end

# lines = IO.readlines('sample10.txt').map(&:strip)
lines = IO.readlines('input10.txt').map(&:strip)

pipeloop = PipeLoop.new lines
puts pipeloop.stepsToFarthestPoint
puts pipeloop.enclosedTileCount

binding.pry pipeloop

# 424 too low
