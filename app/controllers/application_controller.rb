class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

protected

  #def after_sign_in_path_for(resource)
  #  sign_in_and_redirect resource
  #end

  #def after_sign_out_path_for(resource)
    # your_path
  #end
end
