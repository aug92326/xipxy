module SeedLocation
  def self.seed
    # Location.destroy_all
    # 10.times do |n|
    #   generate_location(n)
    # end
    puts "Skip it for now"
  end
  #
  # def self.generate_location(counter=0)
  #   data_location = {
  #     user: User.order("RANDOM()").first,
  #     name:   Faker::Name.name + " #{counter}",
  #     address: Faker::Address.country,
  #     country: Faker::Address.country,
  #     city: Faker::Address.city,
  #     state: Faker::Address.state,
  #     zipcode: Faker::Address.zip_code,
  #     location_notes: Faker::Lorem.sentence,
  #   }
  #
  #   location = Location.new(data_location)
  #   location.save
  # end
end
