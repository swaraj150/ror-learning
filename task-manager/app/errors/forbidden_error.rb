class ForbiddenError < ApplicationError
  def initialize(message = "You are not authorized to perform this action")
    super(
      message: message,
      code:    "forbidden",
      status:  :forbidden
    )
  end
end
