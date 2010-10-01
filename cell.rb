require 'observer'
require 'set'

class Cell
	include Observable
	
	def initialize(value= 0)		
		if (value > 0 && value <= 9)
			@posibilities = Set.new(value)
			@fixed = true
		else
			@posibilities = Set.new(1..9)
      @fixed = false
		end
    @block = []
    @row = nil
    @column = nil
	end

  def set_blocks(block)
    @block.push(block)
  end

  def set_row(row)
    @row = row
  end

  def set_column(column)
    @column = column
  end

  def row
    return @row
  end
  def column
    return @column
  end
  def blocks
    return @block
  end

	def remove_posibility(p)
		if @fixed
			return
		end
		if p.is_a? Array
			@posibilities.subtract(p)
		else
			@posibilities.subtract([p])
		end
		if @posibilities.size == 1
			# trigger removals
			@fixed = true
			changed
			notify_observers(@posibilities.to_a[0])
		end
	end

	def to_s
		return @posibilities.to_a.sort.join(',')
	end

  def fixed
    return @fixed
  end

  def posibilities
    return @posibilities
  end
end
