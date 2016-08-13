class CommentsController < ApplicationController
  before_action :fetch_post

  def index
    @comments = CommentListDecorator.new(@post.comments, view_context)
    render :index, layout: false
  end

  def new
    @new_comment = Comment.new(post_id: @post.id)
    render :new, layout: false
  end

  def create
    @comment = Comment.new(comment_params)
    respond_to do |f|
      f.js do
        if @comment.save
          @comment = CommentDecorator.new(@comment, view_context)
          render :created
        else
          render :failed
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:name, :avatar_url, :profile_link, :text, :post_id)
  end

  def fetch_post
    @post = Post.find_by_slug(params.require(:post_id))
  end
end
