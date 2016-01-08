class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # Including the SessionsHelper module into the base class of all 
  # controllers (the Application controller), we arrange to make  
  # them available in our controllers as well 
  include SessionsHelper
  
end
