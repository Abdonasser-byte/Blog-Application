class PostsController < ApplicationController
    
    before_action :set_post, only: [ :update, :destroy]

    def create
        user = User.find(params[:user_id])
        tag_ids = params[:tag_ids]
    
        if user && tag_ids.present? && post_params[:title].present? && post_params[:body].present?
            @post = Post.new(post_params)
            @post.user = user
    
            # Create an empty array to hold the tag associations
            tag_associations = []
    
            # Iterate through the tag IDs and create tag associations
            tag_ids.each do |tag_id|
            tag = Tag.new(post_id: @post.id, user_id: user.id, tag_id: tag_id)
            tag_associations << tag
        end
    
        if @post.save && Tag.create(tag_associations)
            PostDeletionWorker.perform_in(24.hours, @post.id)
            render json: @post, status: :created
        else
            render json: { error: 'Unable to create post or tags' }, status: :unprocessable_entity
        end
        else
            render json: { error: 'User not found or missing required attributes' }, status: :not_found
        end
    end

    def delete_with_associated
        transaction do
            Comment.where(post_id: id).destroy_all # Delete associated comments with the same post ID
            Tag.joins(:post_tags).where('post_tags.post_id = ?', id).destroy_all # Delete associated tags with the same post ID
            destroy # Delete the post
            tags.each do |tag|
            tag.destroy if tag.posts.empty?
            end
        end
    end

    # PATCH/PUT /posts/1
    def update
        if @post.update(post_params)
            render json: @post
        else
            render json: @post.errors, status: :unprocessable_entity
        end
    end
    
        # DELETE /posts/1
    def destroy
        @post.destroy
    end
    
    private
        # Use callbacks to share common setup or constraints between actions.
        def set_post
            @post = Post.find(params[:id])
        end
    
        # Only allow a trusted parameter "white list" through.
        def post_params
            params.require(:post).permit(
                :title, 
                :name, 
                :body,                 
                )
        end
    
end
