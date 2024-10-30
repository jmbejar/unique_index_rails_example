class Email < ApplicationRecord
  belongs_to :user
  validates :address, presence: true
  # Unique validation at the Rails level
  validates :address, uniqueness: true

  self.ignored_columns += [ "address_old" ]
end
