#!/usr/bin/ruby

class History
	def initialize line
		@values = line.split.map(&:to_i)
		@derivatives = [@values]
		addNextDerivative until @derivatives.last.all?(&:zero?)
	end

	def addNextDerivative
		diffRow = @derivatives.last
		nextRow = (1...diffRow.count).map {|i| diffRow[i] - diffRow[i-1]}
		@derivatives.push nextRow
	end

	def extrapolatedNextValue
		@derivatives.map(&:last).sum
	end

	def extrapolatedPreviousValue
		values = @derivatives.map(&:first).reverse
		value = values[0]
		values[1..-1].each {|v| value = v - value}
		value
	end
end

# lines = IO.readlines('sample09.txt').map(&:strip)
lines = IO.readlines('input09.txt').map(&:strip)

histories = lines.map{|line| History.new line}
puts histories.map(&:extrapolatedNextValue).sum

puts histories.map(&:extrapolatedPreviousValue).sum
