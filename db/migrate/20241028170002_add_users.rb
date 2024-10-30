class AddUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :emails do |t|
      t.string :address, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end

    # Missing unique index on `address` that we want to highlight
  end
end
