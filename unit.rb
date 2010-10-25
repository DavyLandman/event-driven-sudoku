class Unit
	attr_reader :cells
	def initialize(cells)
		@cells = cells
		@cells.each do |m| 
			m.cell_fixed + lambda do |sender, value| 
				@cells.each { |x| x.remove_possibility(value) if not x.equal?(sender) }
			end
		end
	end


  def fixed
  	return @cells.all { |c| c.fixed }
  end

  def correct?
	return (@cells.select{ |m| m.fixed }.map { |m2| m2.possibilities}).uniq!.nil?
  end

  def opencells
  	return @cells.find_all {|m| !m.fixed};
  end

  def remove_singles()
  	candidates = self.opencells
    candidates = candidates.map {|c| 
	  [c, candidates.find_all {|c_other| (c.possibilities == c_other.possibilities)}] }
	  .delete_if { |p| p[0].possibilities.size != p[1].size  }
	candidates.each do |c|
      hiddencells = c.flatten
      (@cells - hiddencells).each { |o|
	  o.remove_possibility(hiddencells.first.possibilities.to_a) }
	end

  end
end
