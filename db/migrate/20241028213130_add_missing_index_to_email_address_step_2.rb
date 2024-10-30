class AddMissingIndexToEmailAddressStep2 < ActiveRecord::Migration[7.2]
  def change
    change_column_null :emails, :address, false

    # Step 1: Create the function
    execute <<-SQL
      BEGIN;

      -- Acquire exclusive lock on the table
      LOCK TABLE emails IN ACCESS EXCLUSIVE MODE;

      -- Remove trigger
      DROP TRIGGER IF EXISTS set_address ON emails;
      DROP FUNCTION IF EXISTS update_address_column();

      -- Rename the columns
      ALTER TABLE emails RENAME COLUMN address TO address_old;
      ALTER TABLE emails ALTER column address_old DROP NOT NULL;
      ALTER TABLE emails RENAME COLUMN address_new TO address;
      ALTER TABLE emails ALTER column address SET NOT NULL;

      COMMIT;
    SQL
  end
end
