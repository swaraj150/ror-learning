class StringCalculator
  DELIMITER = /,|\n/

  def add(input)
    return 0 if input.empty?
    if input.start_with?("//")
      delimiter = input[2]
      input.split(delimiter).sum(&:to_i)
    else
      input.split(DELIMITER).sum(&:to_i)
    end
  end

end