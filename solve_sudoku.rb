#!/usr/bin/env ruby
require 'parse_sudoku'
require 'sudoku'
#require 'ruby-prof-0.7.3/lib/ruby-prof'

if (ARGV.length != 1)
	puts "Supply the sraw filename as the first argument"
end
importedsudoku = parse_sudoku(ARGV[0])
#sd = Sudoku.new()
#sd.start_solving(importedsudoku)
#RubyProf.start
#sd.second_pass()
#result = RubyProf.stop
#sd.print_current()

#puts ''
sd = Sudoku.new()
sd.start_solving(importedsudoku)
puts 'First: '
sd.print_current()
#RubyProf.start
sd.second_pass_full()
#result2 = RubyProf.stop
puts 'Second:'
sd.print_current()

sd.find_pairs()
puts 'Pairs:'
sd.print_current()

sd.remove_subsets()
puts 'Subsets: '
sd.print_current()
=begin
puts "Profiling result 1"
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, 0)
puts "Profiling result 2"
printer = RubyProf::FlatPrinter.new(result2)
printer.print(STDOUT, 0)
=end



