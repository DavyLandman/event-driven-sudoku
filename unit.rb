require 'observer'

class Unit

	def initialize(members)
		@members = members
		@members.each { |m| m.add_observer(self) }
    @fixed = 0
	end
	def update(newfixedValue)
    @fixed += 1
    if (@fixed < 9)
      @members.each { |m| m.remove_posibility(newfixedValue) }
    end
	end

  def fixed
    return @fixed == 9
  end

  def opencells
    if fixed
      return nil
    end
    result = []
    for i in 0...9
      if !(@members[i].fixed)
        result.push(@members[i])
      end
    end
    return result
  end
  def cells
    return @members
  end
  def nonfixed_count
    return 9 - @fixed
  end
end
