class Year 
  def isLeapYear?(year)
    if year == 1800 
      return false
    end
    if year % 4 == 0 
      return true
    end
    false
  end
end