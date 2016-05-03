module SeedExhibitionHistory
  def self.seed
    ExhibitionHistory.destroy_all
    Edition.all.each do |e|
      [1, 2, 3].sample.times do
        ExhibitionHistory.create do |obj|
          obj.edition = e
          obj.displayed_by = Faker::Lorem.word
          obj.displayed_at = Faker::Lorem.word
          obj.title = Faker::Lorem.word
          obj.start_date = Faker::Date.between(120.days.ago, Date.today)
          obj.end_date = Faker::Date.between(120.days.ago, Date.today)
        end
      end
    end

    puts "ExhibitionHistory count = #{ExhibitionHistory.count}"
  end

end
