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
    return [DEFAULT_DELIMITER, input] unless input.start_with?("//")

    header, numbers = input.split("\n", 2)
    if header.include?("[")
      delimiters = header.scan(/\[(.+?)\]/).flatten
      delimiter  = delimiters.length > 1 ? Regexp.union(delimiters) : delimiters.first
    else
      delimiter = header[2]
    end    
    [delimiter, numbers]
  end

  def validate_negatives!(nums)
    negatives = nums.select(&:negative?)
    raise ArgumentError, "negatives not allowed: #{negatives.join(", ")}" if negatives.any?
  end

end