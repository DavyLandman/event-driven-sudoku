#!/usr/bin/env ruby
$:.unshift("lib/ruby-event/lib")
$:.unshift("lib/ruby-event")
$:.unshift(".")

require 'parse_sudoku'
require 'sudoku'
#require 'ruby-prof-0.7.3/lib/ruby-prof'
class Sudoku
	def print_current()	
		width = @sudoku.map{|row| row.map { |cell| cell.possibilities.size} }.flatten!.max
    	width = (width *2) + 1
    	seperator_line = Array.new(3).map{ Array.new(width * 3).map!{'-'}.join + '+' }.join.chop!
		for i in 0...9
			s = ''
			for j in 0...9
				s +=  @sudoku[i][j].to_s.center(width)
				if (j + 1).modulo(3) ==0 && j < 8
					s += '|'
				end
			end
			puts s
			if (i + 1).modulo(3) ==0 && i < 8
				puts  seperator_line
			end
		end
	end
end

if (ARGV.length != 1)
	puts "Supply the sraw filename as the first argument"
end
importedsudoku = parse_sudoku(ARGV[0])
sd = Sudoku.new()
sd.start_solving(importedsudoku)
if sd.is_solved
	puts 'Solved purely using events: '
	sd.print_current()
else
	puts 'We have to make a guess to solve this'
	guess_count = 0
	while not sd.is_solved do
		guess_count += 1
		puts "Trying with #{guess_count} guess(es)"
		sd.try_guessing(guess_count)
	end
	puts "We solved the sudoku using events and #{guess_count} guesses"
	sd.print_current()
end

