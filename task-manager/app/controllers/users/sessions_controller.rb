# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [ :create ]
  respond_to :json

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user&.valid_password?(params[:user][:password])
      jwt_token = JwtService.encode({ user_id: @user.id })
      render json: {
        message: "Logged in successfully",
        token: jwt_token,
        user: user_json(@user)
      }, status: :created
    else
        render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def user_json(user)
    user.as_json(only: [ :id, :email ])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
