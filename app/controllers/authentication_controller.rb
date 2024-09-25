class AuthenticationController < ActionController::Base
  def sign_in
    session[:user_id] = request.headers['user_id']
  end
  
  def sign_out
    session[:user_id] = nil
  end
end
