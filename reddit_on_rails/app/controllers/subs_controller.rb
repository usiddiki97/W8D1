class SubsController < ApplicationController
    before_action :ensure_logged_in!, except: [:index, :show]
    before_action :ensure_moderator!, only: [:edit]

    def index
        @subs = Sub.all
        render :index
    end

    def show
        @sub = Sub.includes(:posts).find(params[:id])
        render :show
    end

    def new
        @sub = Sub.new
        render :new
    end

    def create
        @sub = current_user.subs.new(sub_params)

        if @sub.save
            redirect_to sub_url(@sub)
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    def edit
        @sub = Sub.find(params[:id])
        render :edit
    end

    def update
        @sub = Sub.find([params[:id]])

        if @sub.update(sub_params)
            redirect_to sub_url(@sub)
        else
            flash.now[:errors] = "Something went wrong!"
            render :edit
        end
    end

    private

    def ensure_moderator!
        unless params[:id] == current_user.id
            flash[:errors] = "Need to be the moderator of this sub to edit it!"
            redirect_to subs_url
        end
    end

    def sub_params
        params.require(:sub).permit(:title, :description)
    end
end
