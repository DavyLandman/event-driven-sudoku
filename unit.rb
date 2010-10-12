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
	#return ((1..9).all? {|n| @cells.any? {|m| m.posibilities == n }}) and (@cells.select{ |m| m.fixed }.map { |m2| m2.posibilities}).uniq!.nil?
	return (@cells.select{ |m| m.fixed }.map { |m2| m2.possibilities}).uniq!.nil?
  end
  def opencells
  	return @cells.find_all {|m| !m.fixed};
  end

end
