class CommentsController < ApplicationController
  include ApplicationHelper
  def create
    post_id = params[:post_id]
    @comment = current_user.comments.build(comments_params_with_post)
    if @comment.save
      flash.now[:success] = "Comment made"
      redirect_back_to root_path
    else
      flash[:failure] = "Comment was not made"
      redirect_back_to root_path
    end
  end

  def update
  end

  def destroy
  end

  private

    def comments_params_with_post
      params.require(:comment).permit(:content, :post_id)
    end
end
