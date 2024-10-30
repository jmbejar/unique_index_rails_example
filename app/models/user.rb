class User < ApplicationRecord
  has_many :emails
  validates :name, presence: true
end
