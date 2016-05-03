module SeedPublication
  def self.seed
    Publication.destroy_all
    Edition.all.each do |e|
      [1, 2, 3].sample.times do
        Publication.create do |obj|
          obj.edition = e
          obj.source = Faker::Lorem.word
          obj.title = Faker::Lorem.word
          obj.author = Faker::Lorem.word
          obj.date = Faker::Date.between(120.days.ago, Date.today)
          obj.link = Faker::Internet.url('example.com')
        end
      end
    end

    puts "Publication count = #{Publication.count}"
  end

end
