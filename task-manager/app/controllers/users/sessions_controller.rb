# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_request!, only: [ :create, :refresh ]
  skip_before_action :verify_signed_out_user, only: [ :destroy ]
  respond_to :json

  def create
    @user = User.find_by(email: params[:user][:email])

    unless @user&.valid_password?(params[:user][:password])
      raise UnauthorizedError.new("Invalid email or password")
    end

    access_token  = JwtService.encode_access({ user_id: @user.id })
    refresh_token = JwtService.encode_refresh({ user_id: @user.id })

    @user.update_column(:refresh_token, refresh_token)

    render json: {
      message: "Logged in successfully",
      access_token:  access_token,
      refresh_token: refresh_token,
      user: serialized_user(@user)
    }, status: :ok
  end

  def refresh
    token = extract_token
    decoded = JwtService.decode(token)
    unless decoded[:type] == "refresh"
      raise UnauthorizedError.new("Invalid token type")
    end
    user = User.find_by(refresh_token: token)
    unless user
      raise UnauthorizedError.new("Refresh token revoked or invalid")
    end
    new_access_token = JwtService.encode_access({ user_id: user.id })
    render json: { access_token: new_access_token }, status: :ok
  end

  def destroy
    current_user&.update_column(:refresh_token, nil)
    render json: { message: "Logged out successfully" }, status: :ok
  end


  private

  def serialized_user(user)
    UserSerializer.new(user).as_json
  end

  def user_json(user)
    user.as_json(only: [ :id, :email ])
  end

  def extract_token
    header = request.headers["Authorization"]
    token  = header&.split(" ")&.last

    raise UnauthorizedError.new("Authorization token missing") if token.blank?

    token
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
