#!/usr/bin/ruby

class Coordinates
	attr_reader :row, :column, :origin

	def initialize row, column, origin=nil
		@row, @column, @origin = row, column, origin
	end

	def north
		Coordinates.new @row-1, @column, :south
	end

	def south
		Coordinates.new @row+1, @column, :north
	end

	def east
		Coordinates.new @row, @column+1, :west
	end

	def west
		Coordinates.new @row, @column-1, :east
	end

	def follow pipe
		return north if @origin != :north && PipeLoop::NORTH_CONNECTORS.include?(pipe)
		return south if @origin != :south && PipeLoop::SOUTH_CONNECTORS.include?(pipe)
		return east if @origin != :east && PipeLoop::EAST_CONNECTORS.include?(pipe)
		return west if @origin != :west && PipeLoop::WEST_CONNECTORS.include?(pipe)
		raise ArgumentError("Invalid pipe loop.")
	end

	def at_same_location? other
		@row == other.row && @column == other.column
	end
end

class PipeLoop

	NORTH_CONNECTORS = %w(| L J)
	SOUTH_CONNECTORS = %w(| 7 F)
	EAST_CONNECTORS = %w(- L F)
	WEST_CONNECTORS = %w(- 7 J)

	def initialize input
		@sketch = []
		@start = nil
		input.each do |line|
			startingColumn = line.index 'S'
			@start = Coordinates.new(@sketch.count, startingColumn) unless startingColumn.nil?
			@sketch.push line.chars
		end
	end

	def symbol_at coords
		return '.' if coords.row < 0 || coords.column < 0 ||
			coords.row >= @sketch.count || coords.column >= @sketch[coords.row].count
		@sketch[coords.row][coords.column]
	end

	def stepsToFarthestPoint
		cursors = []
		cursors.push @start.north if SOUTH_CONNECTORS.include? symbol_at(@start.north)
		cursors.push @start.south if NORTH_CONNECTORS.include? symbol_at(@start.south)
		cursors.push @start.east if WEST_CONNECTORS.include? symbol_at(@start.east)
		cursors.push @start.west if EAST_CONNECTORS.include? symbol_at(@start.west)
		raise ArgumentError.new("Invalid starting position") unless cursors.count == 2
		cursorA, cursorB = cursors
		steps = 1
		while true
			cursorA = cursorA.follow(symbol_at cursorA)
			steps += 1
			break if cursorA.at_same_location? cursorB
			cursorB = cursorB.follow(symbol_at cursorB)
			break if cursorA.at_same_location? cursorB
		end
		steps
	end
end

# lines = IO.readlines('sample10.txt').map(&:strip)
lines = IO.readlines('input10.txt').map(&:strip)

pipeloop = PipeLoop.new lines
puts pipeloop.stepsToFarthestPoint
