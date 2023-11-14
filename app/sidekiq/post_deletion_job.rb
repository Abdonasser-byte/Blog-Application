class PostDeletionJob
  include Sidekiq::Job

  def perform(post_id)
    post = Post.find_by(id: post_id)
    if post && post.created_at < 24.hours.ago
      post.destroy
      post&.delete_with_associated
      Rails.logger.info "Post #{post_id} deleted."
    else
      Rails.logger.info "Post #{post_id} not found or not eligible for deletion."
    end
  end
end
