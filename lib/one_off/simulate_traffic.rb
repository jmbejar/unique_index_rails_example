require "net/http"
require "json"
require "securerandom"

API_URL = "http://localhost:3000" # Update if your server URL differs

# Number of users to create
NUM_USERS = 100
# Number of threads to use for parallel requests
NUM_THREADS = 10

# Array to store emails, for introducing duplicates
used_emails = []

# Function to create a user
def create_user(name)
  uri = URI("#{API_URL}/users")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })

  # Body of the request
  request.body = { user: { name: name } }.to_json
  response = http.request(request)
  puts "User creation response for #{name}: #{response.code} - #{response.body}"

  # Return user ID if creation is successful
  JSON.parse(response.body)["id"] if response.code == "201"
end

# Function to add an email to a user
def add_email(user_id, email)
  uri = URI("#{API_URL}/users/#{user_id}/emails")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })

  # Body of the request
  request.body = { email: { address: email } }.to_json
  response = http.request(request)
  puts "Email addition response for #{email}: #{response.code} - #{response.body}"
end

threads = []

# Create threads to simulate concurrent requests
NUM_THREADS.times do
  threads << Thread.new do
    (NUM_USERS / NUM_THREADS).times do
      # Generate a random name for each user
      random_name = "User_#{SecureRandom.hex(4)}"
      user_id = create_user(random_name)

      next unless user_id # Skip if user creation failed

      # Randomly choose whether to generate a duplicate email
      if rand < 0.6 && used_emails.any? # 20% chance of duplicate, if any emails exist
        email = used_emails[0..5].sample # Pick a random email from the used ones
      else
        email = "email_#{SecureRandom.hex(4)}@example.com"
        used_emails << email
      end

      # Add email to the user
      add_email(user_id, email)
    end
  end
end

# Wait for all threads to complete
threads.each(&:join)

puts "Finished creating users and emails!"
