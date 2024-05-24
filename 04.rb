#!/usr/bin/ruby

class Scratchcard

	attr_accessor :id
	def initialize str
		label, numbers = str.split ':'
		@id = label.split(/\s+/)[1].to_i
		@winningNumbers, @posessedNumbers = numbers.split('|').map do |list|
			list.strip.split(/\s+/).map(&:to_i)
		end
		@matches = 0
		@posessedNumbers.each do |number|
			@matches += 1 if @winningNumbers.include? number
		end
	end

	def score
		@matches == 0 ? 0 : 2**(@matches-1)
	end

	def winnings
		@id.upto(@id+@matches).to_a[1..-1]
	end

	def self.totalAllWinnings cards
		copyCounters = cards.to_h{|c| [c.id, 1]}
		cards.each do |card|
			copiesOfThisCard = copyCounters[card.id]
			card.winnings.each do |wonCopy|
				copyCounters[wonCopy] += copiesOfThisCard
			end
		end
		copyCounters.values.sum
	end
end

# lines = IO.readlines('sample04.txt')
lines = IO.readlines('input04.txt')

cards = lines.map{|l| Scratchcard.new l}
puts cards.map(&:score).sum
puts Scratchcard.totalAllWinnings(cards)
