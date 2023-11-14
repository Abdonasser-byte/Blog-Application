class CommentController < ApplicationController
    before_action :set_comment, only: [:update, :destroy]

    def create
        @comment = Comment.new(comment_params)
        @comment.user = current_user 
        if @comment.save
            render json: @comment, status: :created
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end
    
    def update
        authorize_comment
        if @comment.update(comment_params)
            render json: @comment
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end
    def destroy
        authorize_comment
        @comment.destroy
        head :no_content
    end

    private
    def set_comment
        @comment = Comment.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:body, :post_id)
    end

    def authorize_comment
        render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user == @comment.user
    end
end
