#!/usr/bin/ruby

class History
	def initialize line
		@values = line.split.map(&:to_i)
		@derivatives = [@values]
		until @derivatives[-1].all?(&:zero?)
			addPartialDerivative
		end
	end

	def addPartialDerivative
		1.upto(@derivatives.count) do |depth|
			@derivatives[depth] ||= []
			diffRow = @derivatives[depth-1]
			diff = diffRow[-1-@derivatives[depth].count] - diffRow[-2-@derivatives[depth].count]
			@derivatives[depth].unshift diff
		end
	end

	def extrapolatedNextValue
		@derivatives.map(&:last).sum
	end
end

# lines = IO.readlines('sample09.txt').map(&:strip)
lines = IO.readlines('input09.txt').map(&:strip)

histories = lines.map{|line| History.new line}
puts histories.map(&:extrapolatedNextValue).sum
