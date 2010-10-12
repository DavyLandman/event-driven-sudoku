class Unit
	attr_reader :cells
	def initialize(cells)
		@cells = cells
		@cells.each do |m| 
			m.cell_fixed + lambda do |sender, value| 
				@fixed += 1
				if (@fixed < @cells.length)
					@cells.each { |x| x.remove_posibility(value) }
				end
			end
		end
		@fixed = 0
	end


  def fixed
    return @fixed == @cells.length
  end

  def correct?
	#return ((1..9).all? {|n| @cells.any? {|m| m.posibilities == n }}) and (@cells.select{ |m| m.fixed }.map { |m2| m2.posibilities}).uniq!.nil?
	return (@cells.select{ |m| m.fixed }.map { |m2| m2.posibilities}).uniq!.nil?
  end
  def opencells
  	return @cells.find_all {|m| !m.fixed};
  end


  def nonfixed_count
    return @cells.length - @fixed
  end
end
