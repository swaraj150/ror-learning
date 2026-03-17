# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_request!, only: [ :create ]
  skip_before_action :verify_signed_out_user, only: [ :destroy ]
  respond_to :json

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user&.valid_password?(params[:user][:password])
      access_token  = JwtService.encode_access({ user_id: @user.id })
      refresh_token = JwtService.encode_refresh({ user_id: @user.id })
      @user.update_column(:refresh_token, refresh_token)
      render json: {
        message: "Logged in successfully",
        access_token:  access_token,
        refresh_token: refresh_token,
        user: user_json(@user)
      }, status: :ok
    else
        render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def refresh
    token = extract_token
    decoded = JwtService.decode(token)
    unless decoded[:type] == "refresh"
      render json: { error: "Invalid token type" }, status: :unauthorized and return
    end
    user = User.find_by(refresh_token: token)
    unless user
      render json: { error: "Refresh token revoked or invalid" }, status: :unauthorized and return
    end
    new_access_token = JwtService.encode_access({ user_id: user.id })
    render json: { access_token: new_access_token }, status: :ok
  rescue RuntimeError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def destroy
    current_user&.update_column(:refresh_token, nil)
    render json: { message: "Logged out successfully" }, status: :ok
  end


  private

  def user_json(user)
    user.as_json(only: [ :id, :email ])
  end

  def extract_token
    header = request.headers["Authorization"]
    header&.split(" ")&.last  # "Bearer <token>" → "<token>"
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
