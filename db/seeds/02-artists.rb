module SeedArtist
  def self.seed
    Artist.destroy_all
    10.times do |n|
      generate_artist(n)
    end
  end

  def self.generate_artist(counter=0)
    data_artist = {
      brand:   Faker::Name.name + " #{counter}",
      country: Faker::Address.country,
      founded: Faker::Date.between(200.years.ago, 50.years.ago).strftime("%Y").to_i,
      closed: Faker::Date.between(150.years.ago, 1.year.ago).strftime("%Y").to_i
    }

    artist = Artist.new(data_artist)
    artist.save
  end
end
