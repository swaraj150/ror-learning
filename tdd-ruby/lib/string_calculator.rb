class StringCalculator

  def add(input)
    return 0 if input.empty?
    input.split(/,|\n/).sum(&:to_i)
  end

end