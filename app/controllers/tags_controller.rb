class TagsController < ApplicationController
    before_action :set_post
    def add
        tag_name = params[:tag_name]
        tag = Tag.find_or_create_by(name: tag_name, user: current_user)
        if @post.tags << tag
            render json: { message: "Tag '#{tag_name}' added to the post" }
        else
            render json: { error: "Failed to add tag to the post" }, status: :unprocessable_entity
        end
    end
    def remove
        tag_name = params[:tag_name]
        tag = Tag.find_by(name: tag_name, post: @post, user: current_user)
        if tag
            @post.tags.delete(tag)
            render json: { message: "Tag '#{tag_name}' removed from the post" }
        else
            render json: { error: "Tag not found or unauthorized to remove" }, status: :unprocessable_entity
        end
    end

    private

    def set_post
        @post = Post.find(params[:post_id])
    end
end
