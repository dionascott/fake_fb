class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def show
    @user = current_user
    @posts = @user.posts.paginate(page: params[:page], per_page: 25)
    @comment = Comment.new
  end

  def index
    @users = User.all_except(current_user).paginate(page: params[:page], per_page: 10)
  end

  private

end
