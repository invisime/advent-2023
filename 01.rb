#!/usr/bin/ruby

DIGIT_MATCHER = /(one|two|three|four|five|six|seven|eight|nine|\d)/
SINGLE_DIGIT = /\d/

def read_number str
	return str if str =~ SINGLE_DIGIT
	str.gsub('one','1')
     .gsub('two','2')
     .gsub('three','3')
     .gsub('four','4')
     .gsub('five','5')
     .gsub('six','6')
     .gsub('seven','7')
     .gsub('eight','8')
     .gsub('nine','9')
end

def calibration_value str
	first_digit = read_number str[DIGIT_MATCHER]
	last_index = str.rindex(DIGIT_MATCHER)
	second_digit = read_number(str[last_index..-1][DIGIT_MATCHER])
	(first_digit + second_digit).to_i
end

# lines = IO.readlines('sample01.txt')
lines = IO.readlines('input01.txt')

puts lines.map{|l| calibration_value(l) }.sum
