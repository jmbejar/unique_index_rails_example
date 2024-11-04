# Rails script to remove duplicate email addresses, keeping only the first occurrence

Email.where(address_new: nil).find_each(batch_size: 10000) do |email|
  puts "Processing id = #{email.id}" if email.id % 10000 == 0
  # Simply let the DB trigger do its job, copying the address to address_new
  email.touch

  email.reload
  if email.address != email.address_new
    puts "Email address #{email.address} was updated to #{email.address_new} by the DB trigger"
  end
end

puts "Emails addresses were copied"
