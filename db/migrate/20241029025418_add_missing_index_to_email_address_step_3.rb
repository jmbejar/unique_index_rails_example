class AddMissingIndexToEmailAddressStep3 < ActiveRecord::Migration[7.2]
  def change
    remove_column :emails, :address_old
  end
end
