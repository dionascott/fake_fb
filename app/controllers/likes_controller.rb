class LikesController < ApplicationController
  respond_to :js, :json, :html

  def like
    @user = current_user
    @post = Post.find(params[:post_id])
    like = @user.like!(@post)
    flash[:success] = "You liked the post"
    #redirect_back_to posts_path
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def unlike
    @user = current_user
    @like = @user.likes.find_by_post_id(params[:post_id])
    @post = Post.find(params[:post_id])
    @like.destroy!
    flash[:success] = "You unliked the post"
    #redirect_back_to posts_path
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
