class StringCalculator
  DEFAULT_DELIMITER = /,|\n/

  def add(input)
    return 0 if input.empty?
    delimiter,numbers = parse(input)
    numbers.split(delimiter).sum(&:to_i)
  end

  def parse(input)
    if input.start_with?("//")
      delimiter = input[2]
      numbers   = input.split("\n", 2).last
      [delimiter, numbers]
    else
      [DEFAULT_DELIMITER, input]
    end
  end

end