class StringCalculator

  def add(input)
    return 0 if input.empty?
    input.split(",").sum(&:to_i)
  end

end