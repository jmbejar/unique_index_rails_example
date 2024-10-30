class AddMissingIndexToEmailAddress < ActiveRecord::Migration[7.2]
  def change
    add_index :emails, :address, unique: true
  end
end
