# Rails script to remove duplicate email addresses, keeping only the first occurrence

ActiveRecord::Base.transaction do
  # Find all duplicate email addresses
  duplicated_addresses = Email.select(:address)
                              .group(:address)
                              .having("COUNT(*) > 1")
                              .pluck(:address)

  duplicated_addresses.each do |address|
    # Fetch all records with this duplicate address, ordered by creation time
    emails = Email.where(address: address).order(:created_at)

    # Keep the first record, set the rest adding +1, +2, etc. to the address
    i = 1
    emails.drop(1).each do |duplicate_email|
      new_address = "#{duplicate_email.address}+#{i}"
      i = i + 1

      # Update the address and save the record
      duplicate_email.update!(address: new_address)
    end
  end
end

puts "Duplicate emails have been cleaned up."
