class UsersController < ApplicationController
  before_action :require_admin!, only: [ :index ]

  def index
    require_admin!
    @users = User.all
    render json: @user, seach_erializer: UserSerializer
  end

  def show
    @user = User.find(params[:id])
    render json: @users, each_serializer: UserSerializer
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
