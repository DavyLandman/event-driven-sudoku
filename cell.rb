require 'set'
require 'ruby-event'

class Cell
	attr_reader :possibilities, :fixed, :block, :row, :column
	attr_writer :block, :row, :column

	event :cell_fixed

	def initialize(value= 0)		
		initialize_defaults()
		if (value > 0 && value <= 9)
			@possibilities = Set.new(value)
			@fixed = true
		end
	end

	def initialize_defaults()
		@block = []
		@row = @column = nil
		@possibilities = Set.new(1..9)
		@fixed = false
	end
	
	def reset_state(newstate)
		@possibilities = newstate
		@fixed = newstate.size == 1
	end

	def remove_possibility(p)
		@possibilities.subtract(p.is_a?(Array) ? p : [p]) 
		if not @fixed and @possibilities.size == 1
			# trigger removals
			@fixed = true
			cell_fixed(@possibilities.to_a[0])
		end
	end

	def to_s
		return @possibilities.to_a.sort.join(',')
	end
end
