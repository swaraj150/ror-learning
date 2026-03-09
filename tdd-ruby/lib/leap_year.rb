class Year 
  def isLeapYear?(year)
    if year % 400 == 0 
      return true
    end
    if year % 100 == 0 && year % 4 == 0 
      return false
    end
    if year % 4 == 0 
      return true
    end
    false
  end
end