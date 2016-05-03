module SeedTag
  def self.seed
    Tag.destroy_all
    Edition.all.each do |e|
      [1, 2, 3].sample.times do
        e.tags.build(slug: Faker::Lorem.word)
      end
    end

    puts "Tags count = #{Tag.count}"
  end

end
