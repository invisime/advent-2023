#!/usr/bin/ruby

require 'pry'

class Hand

	attr_accessor :bid, :type, :value

	def initialize cards, bid
		@cards, @bid = cards, bid.to_i
		cardCounts = @cards.chars.uniq.to_h{|c|[c,@cards.count(c)]}
		@type = cardCounts.values.sort.join.to_i
		@value = @cards.gsub('A','E').gsub('K','D')
			.gsub('Q','C').gsub('J','B').gsub('T','A').to_i(16)
	end

	def <=>(other)
		typeComparison = other.type <=> self.type
		return typeComparison unless typeComparison == 0
		self.value <=> other.value
	end
end

# lines = IO.readlines('sample07.txt').map(&:strip)
lines = IO.readlines('input07.txt').map(&:strip)

hands = lines.map{|line| Hand.new(*line.split)}.sort
winnings = 1.upto(hands.count).map{|rank| rank * hands[rank-1].bid}
puts winnings.sum

binding.pry
