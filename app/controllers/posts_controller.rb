class PostsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(posts_params)
    if @post.save
      flash[:success] = "Your post was made"
      redirect_to root_path
    else
      flash.now[:alert] = "A problem"
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def index
    @user = current_user
    post_ids = @user.friends_posts_ids
    @posts = Post.where(author_id: post_ids).order(created_at: :desc).paginate(page: params[:page], per_page: 25)
    @comment = Comment.new
  end

  private

    def posts_params
      params.require(:post).permit(:content, :author_id)
    end
end
