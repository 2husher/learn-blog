class UsersController < ApplicationController
  before_action :authenticate, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to articles_path, notice: 'User successfully added.'
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to articles_path, notice: 'Updated user information successfully.'
    else
      render :edit
    end
  end

  private

    def user_params
      params[:user].permit(:email, :password, :password_confirmation)
    end
end