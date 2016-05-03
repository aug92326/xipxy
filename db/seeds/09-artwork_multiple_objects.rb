module SeedArtworkMultipleObject
  def self.seed
    ArtworkMultipleObject.destroy_all
    Record.all.each do |r|
      5.times do
        ArtworkMultipleObject.create do |obj|
          obj.record = r
          obj.name = Faker::Lorem.sentence
          obj.material = 'paper'
          obj.system = ['standard', 'metric'].sample
          obj.weight = BaseUnitSystem.fake_weight
          obj.duration = {hours: Faker::Number.between(0, 24).to_s, minutes: Faker::Number.between(0, 60).to_s, seconds: Faker::Number.between(0, 60).to_s}
          obj.size = BaseUnitSystem.fake_size
        end
      end
    end

    puts "MultipleObject count = #{ArtworkMultipleObject.count}"
  end

end
