class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #redirect to new page
      log_in user
      
      # implement remember me functionaility
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)

      redirect_to user_url(user)
    else
      # display in rendered page and it will disappered in next request
      flash.now[:danger] = "Invalid information!!!"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
