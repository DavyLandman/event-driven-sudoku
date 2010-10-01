#!/usr/bin/env ruby
require 'parse_sudoku'
require 'sudoku'
#require 'ruby-prof-0.7.3/lib/ruby-prof'

if (ARGV.length != 1)
	puts "Supply the sraw filename as the first argument"
end
importedsudoku = parse_sudoku(ARGV[0])
sd = Sudoku.new()
sd.start_solving(importedsudoku)
puts 'First: '
sd.print_current()
