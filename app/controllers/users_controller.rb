class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @likes = @user.likes
    @comments = @user.comments

    # if params[:q]
    #   @q = Post.ransack(params[:q])
    #   @posts = @q.result(distinct: true).page(params[:page])
    # end
  end

end
