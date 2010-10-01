require "cell"
require "unit"
require "set"

class Sudoku
	def initialize()
		@sudoku = Array.new(9).map! { Array.new(9).map! { Cell.new() }}
		@blocks = []
    @rows = []
    @columns = []
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

	def second_pass()
		for r in @rows
			for b in 0...3
				rpart = r.cells.slice(b * 3, 3)
				rother = r.cells- rpart
		        rvalues = Set.new(rpart.map{|c| c.posibilities.to_a}.flatten)
     			cblocks = rpart[0].blocks
		        bcells = cblocks.map {|bl| (bl.cells - rpart) }.flatten
		        all_other_values = Set.new(bcells.map{|c| c.posibilities.to_a}.flatten)
		        left_over = rvalues - all_other_values;
		        if left_over.size > 0
					rother.each {|c| c.remove_posibility(left_over.to_a)}
		        end
     		end
	    end
	end

	def second_pass_faster()
		for r in @rows
			for b in 0...3
				rbcells = r.cells.slice(b*3, 3)
				unique = Set.new()
				for c in rbcells
					if !c.fixed
						unique += c.posibilities
					end
				end
				for block in rbcells[0].blocks
					for c in block.cells
						if c.fixed || rbcells.include?(c)
							next
						end
						unique.subtract(c.posibilities)
					end
					if unique.size == 0
						break
					end
				end
				if unique.size > 0
					rem = unique.to_a
					for c  in r.cells
						if !c.fixed && !rbcells.include?(c)
							c.remove_posibility(rem)
						end
					end
				end							
			end
		end
	end
	def second_pass_full()
		for u in @rows + @columns
			for b in 0..2
				source_cells = u.cells.slice(b*3,3)
				second_pass_generic(u, source_cells, source_cells[0].blocks) 
			end
		end
	end
	def second_pass_generic(unit, source_cells, blocks)
		unique = Set.new()
		for c in source_cells
			if !c.fixed
				unique += c.posibilities
			end
		end
		for block in blocks
			for c in block.cells
				if c.fixed || source_cells.include?(c)
					next
				end
				unique.subtract(c.posibilities)
			end
			if unique.size == 0
				break
			end
		end
		if unique.size > 0
			rem = unique.to_a
			for c  in unit.cells
				if !c.fixed && !source_cells.include?(c)
					c.remove_posibility(rem)
				end
			end
		end	
	end
	#TODO: not completed!
	def find_pairs()
		for r in @rows + @columns + @blocks
			if r.fixed
				next
			end
			cells = r.opencells
			posible_pair = nil
			for	c in cells
				if c.posibilities.size == 2
					posible_pair = c
				end
			end
			if posible_pair == nil
				next
			end
			cells -= [posible_pair]
			for c in cells
				if posible_pair.posibilities == c.posibilities
					cells -= [c]
					if cells != nil
						cells.each {|cell| cell.remove_posibility(posible_pair.posibilities.to_a) }
					end
					break
				end
			end
		end
	end
	#TODO: broken, not correct
	def remove_subsets()
		for b in @blocks
			if b.fixed
				next
			end
			cells = b.opencells
			for c in cells
				sup = c.posibilities
				pair = [c]
				puts "Checking: " + sup.to_a.to_s
				for find in cells
					if find == c
						next
					end
					puts "subset testing: " + find.to_s
					if (find.posibilities.subset?(sup))
						pair.push(find)
						puts "Found: " + find.to_s
					end
				end
				if pair.length > 1
					for cr in cells
						if !pair.include?(cr)
							cr.remove_posibility(sup.to_a)
						end
					end
					break
				end
			end
		end
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
