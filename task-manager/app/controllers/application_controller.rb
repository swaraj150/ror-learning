class ApplicationController < ActionController::API
  before_action :authenticate_request!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes

  private
  def extract_token
    header = request.headers["Authorization"]
    header&.split(" ")&.last  # "Bearer <token>" → "<token>"
  end

  def authenticate_request!
    token = extract_token
    unless token
      render json: { error: "No token provided" }, status: :unauthorized and return
    end

    begin
      decoded  = JwtService.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :unauthorized
    rescue RuntimeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def require_admin!
    unless current_user&.admin?
      render json: { error: "Admin access required" }, status: :forbidden
    end
  end
end
