class PostsController < ApplicationController

    before_action :ensure_logged_in!, except: [:show]

    def show
        @post = Post.find(params[:id])
    end

    def new
        @post = Post.new
        render :new
    end

    def create
        @post = Post.new(post_params)
        @post.author_id = current_user.id

        if @post.save
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end

    
    def edit
        @post = Post.find(params[:id])
        if @post.author == current_user
            render :edit
        end
    end
    
    def update
        @post = Post.find(params[:id])

        if @post.update(post_params)
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :edit
        end
    end

    

    private
    
    def post_params
        params.require(:post).permit(:title, :url, :content, :sub_id)
    end
end
