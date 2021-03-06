class UsersController < ApplicationController
  before_action :check_current_user, except: [:new, :create, :show]
  before_action :set_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      Resque.enqueue(EmailJob, @user.id)
      session[:user_id] = @user.id
      flash[:notice] = "List a list"
      redirect_to "/profile"
    else
      render :new
    end
  end

  def show
  end

  def delete
    @user.destroy
    flash[:notice] = "You have successfully deleted your account."
    redirect_to root_url
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end

