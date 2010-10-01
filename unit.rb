require 'observer'

class Unit

	def initialize(members)
		@members = members
		@members.each { |m| m.add_observer(self) }
		@fixed = 0
	end

	def update(newfixedValue, old=-1, sender=nil)
		if other == -1
			@fixed += 1
			if (@fixed < @members.length)
				@members.each { |m| m.remove_posibility(newfixedValue) }
			end
		end
	end

  def fixed
    return @fixed == @members.length
  end

  def opencells
    if fixed
      return nil
    end
  	return @members.find_all {|m| !m.fixed};
  end

  def cells
    return @members
  end

  def nonfixed_count
    return @members.length - @fixed
  end
end
