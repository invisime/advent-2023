#!/usr/bin/ruby

class GameRecord

	attr_reader :id

	NUMBER_REGEX = /\d+/

	def initialize str
		label, log = str.split(':')
		@id = label[NUMBER_REGEX].to_i
		@reveals = []
		log.split(';').each do |reveal|
			reveal_hash = {}
			reveal.split(',').each do |color|
				count, name = color.split(' ')
				reveal_hash[name] = count.to_i
			end
			@reveals << reveal_hash
		end
	end

	def possible? red=12, green=13, blue=14
		return @reveals.all? do |reveal_hash|
			 (reveal_hash['red']   || 0) <= red   &&
			 (reveal_hash['green'] || 0) <= green &&
			 (reveal_hash['blue']  || 0) <= blue
		end
	end

	def minimum_cube_power
		red   = @reveals.map{|h| h['red']   || 1}.max
		green = @reveals.map{|h| h['green'] || 1}.max
		blue  = @reveals.map{|h| h['blue']  || 1}.max
		red * green * blue
	end
end

# lines = IO.readlines('sample02.txt')
lines = IO.readlines('input02.txt')

all_games = lines.map{|l| GameRecord.new l }
possible_games = all_games.filter{|g| g.possible? }

puts possible_games.map(&:id).sum

puts all_games.map{|g| g.minimum_cube_power}.sum
