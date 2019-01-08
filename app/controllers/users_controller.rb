class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])  
  end
  
  def create
    @user = User.new(user_params)
    if @user.save 
      #display a successful message to user
      flash[:success] = "Login to the page"
      # short syntax: redirect_to login page
      redirect_to login_path
    else
      render 'new'
    end
  end

  private
    
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
  end         
end
