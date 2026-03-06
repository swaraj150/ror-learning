class StringCalculator
  DEFAULT_DELIMITER = /,|\n/

  def add(input)
    return 0 if input.empty?
    delimiter,numbers = parse(input)
    
    nums = numbers.split(delimiter).map(&:to_i).reject { |n| n > 1000}
    
    validate_negatives!(nums)
    
    nums.sum
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

  def validate_negatives!(nums)
    negatives = nums.select(&:negative?)
    raise ArgumentError, "negatives not allowed: #{negatives.join(", ")}" if negatives.any?
  end

end