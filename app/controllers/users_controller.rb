class UsersController < ApplicationController
  include ApplicationHelper
  before_action :logged_in

  def show
    @user = current_user
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  private

end
