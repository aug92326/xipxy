module SeedArtwork
  def self.seed
    ExternalArtwork.destroy_all
    40.times do |n|
      generate_artwork(n)
    end
  end

  def self.generate_artwork(counter=0)
    data_artwork = {
      artist: Artist.order("RANDOM()").first,
      model: Faker::Name.name + " #{counter}",
      year: Faker::Date.between(200.years.ago, 50.years.ago).strftime("%Y").to_i,
      material: 'paper',
      system: ['standard', 'metric'].sample,
      weight: BaseUnitSystem.fake_weight,
      duration: {hours: Faker::Number.between(0, 24).to_s, minutes: Faker::Number.between(0, 60).to_s, seconds: Faker::Number.between(0, 60).to_s},
      size: BaseUnitSystem.fake_size
    }

    artwork = ExternalArtwork.new(data_artwork)
    artwork.save
  end
end
