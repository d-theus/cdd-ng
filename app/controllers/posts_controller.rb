class PostsController < ApplicationController
  before_action :authenticate, except: [:index, :show]
  before_action :build_post, only: [:new, :create]
  before_action :fetch_post, only: [:edit, :update, :show, :destroy]
  before_action :fetch_pictures, only: [:new, :edit, :update]

  def new
  end

  def edit
  end

  def show
    if request.path != post_path(@post)
      redirect_to post_path(@post), status: :moved_permanently
    end
    @see_also = Post.where.not(id: @post)
  end

  def index
    @posts = PostListDecorator.new(
      Post.order('created_at DESC').paginate(per_page: 10, page: params[:page]).includes(:pictures, :tags),
      view_context
    )
    @tags = ActsAsTaggableOn::Tag.most_used(100)
  end

  def create
    @post.assign_attributes(post_params)
    if @post.save
      flash.now[:notice] = 'All went well. Post created.'
      redirect_to post_path(id: @post.slug)
    else
      flash.now[:alert] = 'Something went wrong'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post.assign_attributes(post_params)
    if @post.save
      flash.now[:notice] = 'All went well. Post updated.'
      redirect_to post_path(@post)
    else
      flash.now[:alert] = 'Something went wrong'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      flash.now[:notice] = 'Succesfully deleted post.'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Cannot delete this post.'
      render :edit
    end
  end

  def preview
    extend PostsHelper
    render text: render_post_text(params[:post][:text])
  end

  private

  def post_params
    params.require(:post).permit(:title, :text, :tag_list, :slug)
  end

  def build_post
    @post = Post.new
  end

  def fetch_post
    @post = Post.friendly.find(params[:id])
  end

  def fetch_pictures
    @pictures = PostPicture.order('created_at DESC')
  end
end

