class AddMissingIndexToEmailAddressStep1 < ActiveRecord::Migration[7.2]
  def up
    add_column :emails, :address_new, :string
    add_index :emails, :address_new, unique: true

    # Step 1: Create the function
    execute <<-SQL
      CREATE OR REPLACE FUNCTION update_address_column()
      RETURNS TRIGGER AS $$
      DECLARE
        current_number INT;
        duplicated_address_last VARCHAR;
      BEGIN
        IF EXISTS (SELECT 1 FROM emails WHERE address_new = NEW.address AND id <> NEW.id) THEN
          -- This is a duplicate email address.
          duplicated_address_last := (SELECT address_new FROM emails WHERE starts_with(address_new, NEW.address) AND address_new <> NEW.address ORDER BY address_new DESC LIMIT 1);
          -- First, check if it has an appended number, with the form +1, +2, etc.#{'          '}
          IF duplicated_address_last ~ '\\+\\d+$' THEN
            -- Extract the number from the address
            current_number := (regexp_matches(duplicated_address_last, '\\+(\\d+)$'))[1]::int + 1;
            NEW.address_new := regexp_replace(duplicated_address_last, '\\+\\d+$', '') || '+' || current_number;
          ELSE
            -- Append +1 to the address
            NEW.address_new := NEW.address || '+1';
          END IF;
        ELSE
          NEW.address_new := NEW.address;
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    # Step 2: Create the trigger
    execute <<-SQL
      CREATE TRIGGER set_address
      BEFORE INSERT OR UPDATE ON emails
      FOR EACH ROW
      EXECUTE FUNCTION update_address_column();
    SQL
  end

  def down
    # Step 1: Drop the trigger
    execute <<-SQL
      DROP TRIGGER IF EXISTS set_address ON emails;
    SQL

    # Step 2: Drop the function
    execute <<-SQL
      DROP FUNCTION IF EXISTS update_address_column();
    SQL

    remove_index :emails, :address_new
    remove_column :emails, :address_new
  end
end
