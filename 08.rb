#!/usr/bin/ruby

# lines = IO.readlines('sample08.txt').map(&:strip)
lines = IO.readlines('input08.txt').map(&:strip)

steps = lines[0].gsub('L','0').gsub('R','1').chars.map(&:to_i)
nodes = lines[2..-1].to_h do |line|
	args = line.split ' = '
	args[1] = args[1][1..-2].split ', '
	args
end

node = 'AAA'
step = 0
until node == 'ZZZ'
	node = nodes[node][steps[step % steps.count]]
	step += 1
end
puts step

unfinishedNodes = nodes.keys.select{|name| name.end_with?('A')}
stepsRequired = 1
step = 0
while unfinishedNodes.any?
	nextNodes = []
	unfinishedNodes.each do |name|
		nextNodeName = nodes[name][steps[step % steps.count]]
		if nextNodeName.end_with? 'Z'
			stepsRequired = stepsRequired.lcm(step + 1)
		else
			nextNodes.push nextNodeName
		end
	end
	unfinishedNodes = nextNodes
	step += 1
end
puts stepsRequired
