class StringCalculator
  DELIMITER = /,|\n/

  def add(input)
    return 0 if input.empty?
    input.split(DELIMITER).sum(&:to_i)
  end

end