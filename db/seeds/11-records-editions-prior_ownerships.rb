module SeedPriorOwnership
  def self.seed
    PriorOwnership.destroy_all
    Edition.all.each do |e|
      [1, 2, 3].sample.times do
        PriorOwnership.create do |obj|
          obj.edition = e
          obj.owner = Faker::Lorem.word
          obj.purchase_price = Faker::Number.decimal(2)
          obj.sale_price = Faker::Number.decimal(2)
          obj.date_of_purchase = Faker::Date.between(120.days.ago, Date.today)
          obj.date_of_sale = Faker::Date.between(120.days.ago, Date.today)
        end
      end
    end

    puts "PriorOwnership count = #{PriorOwnership.count}"
  end

end
