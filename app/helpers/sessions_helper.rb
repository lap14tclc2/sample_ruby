module SessionsHelper
  def log_in(user)
    #temporary cookies created using session() method are automatically encrypted
    session[:user_id] = user.id
  end
    
  def current_user
    #check if session was existed then assign it to user_id variable
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # check if cookie was existed then assign it to user_id variable
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # check remember token is matched the remember digest
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  #log out the current suer
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    # create a random remember token and save the encrypted token to database
    user.remember
    # signed() method automatically encrypt the user's id for security purpose
    cookies.permanent.signed[:user_id] = user.id
    # save the remember token to cookie for comparing lately 
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
