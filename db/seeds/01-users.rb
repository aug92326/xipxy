module SeedUser
  def self.seed
    User.destroy_all
    10.times do |n|
      generate_user(n)
    end
  end

  def self.generate_user(counter=0, role_name='test')
    data_user = {
      email:                 "#{role_name}_#{counter}@mail.com",
      password:              '1qaz!QAZ',
      password_confirmation: '1qaz!QAZ',
    }

    user = User.new(data_user)
    user.skip_confirmation!
    user.save

    #ensure profile
    profile_params = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      mailing_address: "#{Faker::Address.street_address} #{Faker::Address.building_number}",
      country: Faker::Address.country,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zipcode: Faker::Address.zip_code,
      phone: Faker::PhoneNumber.phone_number,
      alternative_email: Faker::Internet.email
    }
    user.profile.update(profile_params)
  end
end
