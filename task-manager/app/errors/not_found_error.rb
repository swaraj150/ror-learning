class NotFoundError < ApplicationError
  def initialize(resource = "Resource")
    super(
      message: "#{resource} not found",
      code:    "not_found",
      status:  :not_found
    )
  end
end
