module SessionsHelper
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def logged_in
    if current_user == nil
      flash[:alert] = "You need to be signed in to view this page."
      redirect_to root_path
    end
  end
end
