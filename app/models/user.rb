class User < ApplicationRecord
    has_one_attached :image
    validates_uniqueness_of :email

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :tags , dependent: :destroy
end
