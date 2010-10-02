class Unit

	def initialize(members)
		@members = members
		@members.each do |m| 
			m.cell_fixed + lambda do |sender, value| 
				@fixed += 1
				if (@fixed < @members.length)
					@members.each { |x| x.remove_posibility(value) }
				end
			end
		end
		@fixed = 0
	end


  def fixed
    return @fixed == @members.length
  end

  def correct?
	#return ((1..9).all? {|n| @members.any? {|m| m.posibilities == n }}) and (@members.select{ |m| m.fixed }.map { |m2| m2.posibilities}).uniq!.nil?
	return (@members.select{ |m| m.fixed }.map { |m2| m2.posibilities}).uniq!.nil?
  end
  def opencells
  	return @members.find_all {|m| !m.fixed};
  end

  def cells
    return @members
  end

  def nonfixed_count
    return @members.length - @fixed
  end
end
