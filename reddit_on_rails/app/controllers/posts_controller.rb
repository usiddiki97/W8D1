class PostsController < ApplicationController
    before_action :ensure_logged_in!, except: [:show]
    before_action :ensure_author!, only: [:edit, :update]

    def show
        @spost = Post.find(params[:id])
        render :show
    end

    def new
        @post = Post.new
        render :new
    end

    def create
        @post = current_user.posts.new(post_params)

        if @post.save
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end

    def edit
        @post = Post.find(params[:id])
        render :edit
    end

    def update
        @post = Post.find([params[:id]])

        if @post.update(post_params)
            redirect_to post_url(@post)
        else
            flash.now[:errors] = "Something went wrong!"
            render :edit
        end
    end

    private

    def ensure_author!
        unless params[:id] == current_user.id
            flash[:errors] = "Only the author of this post can edit it"
            redirect_to post_url(params[:id])
        end
    end

    def post_params
        params.require(:post).permit(:title :url, :content, :sub_id)
    end
end
