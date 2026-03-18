class ApplicationController < ActionController::API
  include Paginable
  include ErrorHandler
  before_action :authenticate_request!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes

  private
  def extract_token
    header = request.headers["Authorization"]
    token  = header&.split(" ")&.last
    raise UnauthorizedError.new("No token provided") if token.blank?
    token
  end

  def authenticate_request!
    token = extract_token
    decoded = JwtService.decode(token)
    unless decoded[:type] == "access"
      raise UnauthorizedError.new("Invalid token type")
    end
    @current_user = User.find(decoded[:user_id])
    raise UnauthorizedError.new("User not found") unless @current_user
  end

  def current_user
    @current_user
  end

  def require_admin!
    aise ForbiddenError unless current_user&.admin?
  end
end
