require "cell"
require "unit"
require "set"

class Sudoku
	def initialize()
		@sudoku = Array.new(9).map! { Array.new(9).map! { Cell.new() }}
		initialize_units()
	end


	def start_solving(startValues)
		# just fill in the values we know
		for i in 0...9
			for j in 0...9
				if startValues[i][j] != 0
					@sudoku[i][j].remove_possibility((1..9).to_a - [startValues[i][j]])
				end
			end
		end
	end

	def is_solved()
		return @sudoku.all? {|row| row.all? { |cell| cell.fixed } }
	end
	def is_correct()
		return (@blocks + @rows + @columns).all? {|u| u.correct? }
	end
	def all_units
		return (@blocks + @rows + @columns)
	end
	
	def try_removing_singles()
		all_units.each { |u| u.remove_singles() }
	end

	def try_guessing(amount)
		make_guess(amount)
	end

	def make_guess(amount)
		try_removing_singles()
		possible_targets = @sudoku.flatten.select { |c| c.possibilities.size > 1}.sort_by { |c1| c1.possibilities.size }
		possible_targets.each do |suitable|
			suitable.possibilities.each do |value| 
				snapshot = History.new(@sudoku)
				suitable.remove_possibility(suitable.possibilities.to_a - [value])
				if !is_solved and is_correct and amount > 0
					make_guess(amount - 1)
				end
				break if is_solved and is_correct
				snapshot.restore()
			end
			break if is_solved and is_correct			
		end
	end

	def initialize_units()
		@blocks = []
		@rows = []
		@columns = []

		@blocks.push(Unit.new(get_unit(0..2, 0..2)))
		@blocks.push(Unit.new(get_unit(3..5, 0..2)))
		@blocks.push(Unit.new(get_unit(6..8, 0..2)))
		@blocks.push(Unit.new(get_unit(0..2, 3..5)))
		@blocks.push(Unit.new(get_unit(0..2, 6..8)))
		@blocks.push(Unit.new(get_unit(3..5, 3..5)))
		@blocks.push(Unit.new(get_unit(6..8, 3..5)))
		@blocks.push(Unit.new(get_unit(3..5, 6..8)))
		@blocks.push(Unit.new(get_unit(6..8, 6..8)))
		@blocks.each { |b| b.cells.each { |c| c.block << b} }


		for	i in 0...9
			@rows.push(Unit.new(@sudoku[i]))
			@columns.push(Unit.new(get_unit(0..8, i)))
		end
		@rows.each {|r| r.cells.each { |c| c.row = r}}
		@columns.each {|col| col.cells.each { |c| c.column = col}}
	end

	def get_unit(i,j)
		result = []
		if (j.is_a? Numeric)
			for x in i
				result.push(@sudoku[x][j])
			end
		else
			for x in i
				result = result + @sudoku[x][j]
			end
		end
		return result
	end
end

class History
	def initialize(sudoku)
		@history = sudoku.flatten.map { |c| [c, c.possibilities.clone] }
	end
	def restore()
		@history.each do |change| 
			change[0].reset_state(change[1])
		end
	end
end
