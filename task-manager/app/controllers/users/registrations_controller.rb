# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_request!,   only: [ :create ]
  skip_before_action :authenticate_scope!,     only: [ :update, :destroy ]
  skip_before_action :require_no_authentication, only: [ :create ]
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    if @user.save
      render json: {
        message: "Signed up successfully",
        user: user_json(@user)
      }, status: :created
    else
        render json: { errors: @user.errors }, status: :unprocessable_content
    end
  end

  def update
    @user = current_user
    if @user.update(account_update_params)
      render json: { message: "Account updated", user: @user.as_json }, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_content
    end
  end

  def destroy
    current_user.destroy
    render json: { message: "Account deleted successfully" }, status: :ok
  end

  private

  def user_json(user)
    user.as_json(only: [ :id, :email ])
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
