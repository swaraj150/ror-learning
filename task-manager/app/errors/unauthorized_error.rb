class UnauthorizedError < ApplicationError
  def initialize(message = "Authentication required")
    super(
      message: message,
      code:    "unauthorized",
      status:  :unauthorized
    )
  end
end
