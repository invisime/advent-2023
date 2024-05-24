#!/usr/bin/ruby

class EngineSchematic
	attr_reader :partNumbers, :gears

	def initialize data
		@data = data.map(&:chomp).map(&:chars)
		@height = @data.count
		@width = @data[0].count
		findPartNumbers
		findGears
	end

	private
	GEAR = /\*/
	SINGLE_DIGIT = /\d/
	SYMBOL = /[^\d|\.\s]/

	def findPartNumbers
		@partNumbers = []
		currentNumber = ""
		verifiedAsPart = false
		@height.times do |r|
			@width.times do |c|
				isDigit = SINGLE_DIGIT.match? @data[r][c]
				if isDigit
					currentNumber += @data[r][c]
					verifiedAsPart ||= isAdjacentToSymbol? r, c
				end
				if c+1 == @width || !isDigit
					@partNumbers.push currentNumber.to_i if verifiedAsPart
					currentNumber = ""
					verifiedAsPart = false
				end
			end
		end
	end

	def isAdjacentToSymbol? r, c
		adjacenctValues = ""
		adjacenctValues += @data[r-1][c-1] if isInBounds?(r-1, c-1)
		adjacenctValues += @data[r-1][c  ] if isInBounds?(r-1, c)
		adjacenctValues += @data[r-1][c+1] if isInBounds?(r-1, c+1)
		adjacenctValues += @data[r  ][c-1] if isInBounds?(r, c-1)
		adjacenctValues += @data[r  ][c+1] if isInBounds?(r, c+1)
		adjacenctValues += @data[r+1][c-1] if isInBounds?(r+1, c-1)
		adjacenctValues += @data[r+1][c  ] if isInBounds?(r+1, c)
		adjacenctValues += @data[r+1][c+1] if isInBounds?(r+1, c+1)
		SYMBOL.match? adjacenctValues
	end

	def isInBounds? r, c
		0 <= r && r < @height &&
		0 <= c && c < @width
	end

	def findGears
		@gears = []
		@height.times do |r|
			@width.times do |c|
				if @data[r][c].match? GEAR
					adjacentParts =
						partsOnOrNextTo(r-1,c) +
						partsOnOrNextTo(r  ,c) +
						partsOnOrNextTo(r+1,c)
					@gears.push adjacentParts if adjacentParts.count == 2
				end
			end
		end
	end

	def partsOnOrNextTo r, c
		return [] unless isInBounds? r, c
		if SINGLE_DIGIT.match? @data[r][c]
			left, right = c, c
			left  -= 1 while SINGLE_DIGIT.match? @data[r][left-1]
			right += 1 while SINGLE_DIGIT.match? @data[r][right+1]
			return [ @data[r][left..right].join.to_i ]
		else
			leftAndRightParts = []
			isPartLeft  = SINGLE_DIGIT.match? @data[r][c-1]
			isPartRight = SINGLE_DIGIT.match? @data[r][c+1]
			leftAndRightParts += partsOnOrNextTo(r, c-1) if isPartLeft
			leftAndRightParts += partsOnOrNextTo(r, c+1) if isPartRight
			return leftAndRightParts
		end
	end
end

# lines = IO.readlines('sample03.txt')
lines = IO.readlines('input03.txt')

schematic = EngineSchematic.new(lines)
puts schematic.partNumbers.sum
puts schematic.gears.map{|g| g[0] * g[1] }.sum
