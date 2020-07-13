class CommentsController < ApplicationController

  def create
    @comment = Comment.create(comment_params)
    if @comment.save
      redirect_to post_path(@comment.post.id), notice:"Create a comment!"
    else
      redirect_to post_path(@comment.post.id)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to user_path(current_user), notice:"Delete a Comment「#{comment.text}」!"
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, post_id: params[:post_id])
  end

end

