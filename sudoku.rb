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
		@histories = [History.new]
		for	i in 0...9
			for j in 0...9
				if startValues[i][j] != 0
					@sudoku[i][j].remove_posibility((1..9).to_a - [startValues[i][j]])
				end
			end
		end
    end

	def is_solved()
		return @sudoku.all? {|row| row.fixed }
	end

	def start_guessing()
		suitable = @sudoku.flatten.min { |c1, c2| c1.posibilities.size <=> c2.posibilities.size }
		
	end
	def print_current()	
		width = @sudoku.map{|row| row.map { |cell| cell.posibilities.size} }.flatten!.max
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
end
