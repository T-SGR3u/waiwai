class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index,:show]

  def index
    @posts = Post.includes(:user)
    @like = Like.new
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)
    if post.save
      redirect_to posts_url,notice: "Posted a 「#{post.name}」!"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to posts_url, notice:"Updated a 「#{post.name}」!"
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_url, notice:"Delete a 「#{post.name}」!"
  end

  private

  def post_params
    params.require(:post).permit(:name,:review,:score,:image,:link).merge(user_id: current_user.id)
  end
end
