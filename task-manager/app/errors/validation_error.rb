class ValidationError < ApplicationError
  def initialize(record)
    super(
      message: "Validation failed",
      code:    "validation_error",
      status:  :unprocessable_content,
      details: format_errors(record)
    )
  end

  private

  def format_errors(record)
    record.errors.map do |error|
      {
        field:   error.attribute,
        message: error.message,
        full_message: error.full_message
      }
    end
  end
end
