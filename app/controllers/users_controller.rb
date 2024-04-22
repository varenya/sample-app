class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_param)
    if @user.save
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private
    def user_param
      params.require(:user).permit(:email, :password,:password_confirmation)
    end

end
