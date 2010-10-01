require "cell"
require "unit"
require "set"

class Sudoku
	def initialize()
		@sudoku = Array.new(9).map! { Array.new(9).map! { Cell.new() }}
		@blocks = []
		@rows = []
		@columns = []
		@histories = []
		initialize_blocks()
	end

	def start_solving(startValues)
		for	i in 0...9
			for j in 0...9
				if startValues[i][j] != 0
					@sudoku[i][j].remove_posibility((1..9).to_a - [startValues[i][j]])
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



	def start_guessing()
		possible_targets = @sudoku.flatten.select { |c| c.posibilities.size > 1}.sort_by { |c1| c1.posibilities.size }
		possible_targets.each do |suitable|
			suitable.posibilities.each do |value| 
				@histories << History.new
				suitable.remove_posibility(suitable.posibilities.to_a - [value])
				if !is_solved and is_correct
					start_guessing()
				end
				break if is_solved and is_correct
				@histories.pop.undo()
			end
			break if is_solved and is_correct			
		end
		print_current if @histories.length < 10
	end

	def update(newfixedValue, oldValue=-1, sender=nil)
		if  oldValue != -1 and !@histories.empty?
			# we have to store history
			@histories.last.add_change(newfixedValue, oldValue, sender)
		end
	end

	def initialize_blocks()
		@blocks.push(Unit.new(get_unit(0..2, 0..2)))
		@blocks.push(Unit.new(get_unit(3..5, 0..2)))
		@blocks.push(Unit.new(get_unit(6..8, 0..2)))
		@blocks.push(Unit.new(get_unit(0..2, 3..5)))
		@blocks.push(Unit.new(get_unit(0..2, 6..8)))
		@blocks.push(Unit.new(get_unit(3..5, 3..5)))
		@blocks.push(Unit.new(get_unit(6..8, 3..5)))
		@blocks.push(Unit.new(get_unit(3..5, 6..8)))
		@blocks.push(Unit.new(get_unit(6..8, 6..8)))
		@blocks.each { |b| b.cells.each { |c| c.set_blocks(b)} }


		for	i in 0...9
			@rows.push(Unit.new(@sudoku[i]))
			@columns.push(Unit.new(get_unit(0..8, i)))
		end
		@rows.each {|r| r.cells.each { |c| c.set_row(r)}}
		@columns.each {|col| col.cells.each { |c| c.set_column(col)}}
		
		@rows.each {|r| r.cells.each { |c| c.add_observer(self)}}
		@columns.each {|col| col.cells.each { |c| c.add_observer(self)}}
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
	def initialize()
		@history = []
	end
	def add_change(new, old, cell)
		@history << [new, old, cell]
	end
	def undo()
		@history.reverse.each do |change| 
			change[2].reset_state(change[1])
		end
	end
end
