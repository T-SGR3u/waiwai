class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index,:show]

  def index
    @posts = Post.includes(:user).page(params[:page]).per(8).order(created_at: :desc)
    @like = Like.new
    @hash = Gmaps4rails.build_markers(@posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow render_to_string(partial: "posts/infowindow", locals: { post: post })
    end
  end

  def new
    @post = Post.new
    @images = @post.images.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_url,notice: "Posted a 「#{@post.name}」!"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @hash = Gmaps4rails.build_markers(@post) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow render_to_string(partial: "posts/infowindow", locals: { post: post })
    end

    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)

    @images = @post.images
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice:"Updated a 「#{@post.name}」!"
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice:"Delete a 「#{post.name}」!"
  end

  private

  def post_params
    params.require(:post).permit(:name,:review,:score,:link,:address,:latitude,:longitude,images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)
  end
end
