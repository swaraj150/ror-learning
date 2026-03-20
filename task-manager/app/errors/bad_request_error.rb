class BadRequestError < ApplicationError
  def initialize(message = "Bad request")
    super(
      message: message,
      code:    "bad_request",
      status:  :bad_request
    )
  end
end
