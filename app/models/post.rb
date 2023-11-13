class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :tags, presence: true
  has_many :tags

  validate :at_least_one_tag

  def at_least_one_tag
    errors.add(:base, 'A post must have at least one tag') if tags.empty?
  end
end


