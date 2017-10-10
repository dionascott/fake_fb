class RelationshipsController < ApplicationController
  include ApplicationHelper
  before_action :logged_in

  def create
    @user = User.find(params[:user_id])
    current_user.invite(@user)
    Notification.create(sender_id: current_user.id, recipient_id: @user.id)
    flash[:success] = "You are friends with #{@user.email}"
    redirect_to current_user
  end

  def delete
  end

end
