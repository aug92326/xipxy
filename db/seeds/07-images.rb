module SeedImage
  def self.seed
    Image.destroy_all
    Edition.all.each do |e|
      [1, 2, 3].sample.times do
        image = begin
          fn = "bg#{(1..9).to_a.sample}.jpg"
          File.open(File.join(Rails.root, 'db', 'fixtures', 'images', fn))
        end

        Image.create do |img|
          img.edition = e
          img.copyright_holder = Faker::Lorem.sentence
          img.licensing_agency = Faker::Lorem.sentence
          img.image = image
          img.resolution = Faker::Lorem.sentence
          img.credit_line = Faker::Lorem.sentence
          img.licensing_fee = Faker::Lorem.sentences.join(' ')
        end
      end
    end

    puts "Image count = #{Image.count}"
  end

end
