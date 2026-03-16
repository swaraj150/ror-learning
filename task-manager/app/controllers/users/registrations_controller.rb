# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    puts @user
    if @user.save
      render json: {
        message: "Signed up successfully",
        user: user_json(@user)
      }, status: :created
    else
        render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_json(user)
    user.as_json(only: [ :id, :email ])
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
