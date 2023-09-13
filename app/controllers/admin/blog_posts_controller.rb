class Admin::BlogPostsController < Admin::BaseController
  before_action :set_blog_post, only: [:update, :show, :edit, :destroy]

  def index
    @blog_posts = BlogPost.all
  end

  def new
    @blog_post = BlogPost.new
  end

  def show; end

  def edit; end

  def create
    @blog_post = BlogPost.new blog_post_params
    if @blog_post.save
      redirect_to admin_blog_posts_path
    else
      render :new
    end       
  end

  def update
    if @blog_post.update blog_post_params
      redirect_to admin_blog_posts_path
    else
      render :edit
    end
  end

  def destroy
    if @blog_post.destroy
      redirect_to admin_blog_posts_path
    end
  end

  private

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  def blog_post_params
    params.require(:blog_post).permit :title, :content, :published
  end
end
