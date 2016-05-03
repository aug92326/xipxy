module SeedEdition
  def self.seed
    Edition.where(primary: false).destroy_all
    Record.all.each do |r|
      [1, 2].sample.times do
        edition = Edition.create do |obj|
          obj.record = r
          obj.edition_type = ['Editions', "Artist's Proof", "Printer's Proof"].sample
          obj.primary_status = ['Owned', "Consigned from #{User.order("RANDOM()").first.id}"].sample,
          obj.secondary_status = ["On Reserve for #{User.order("RANDOM()").first.id}", "Consigned #{User.order("RANDOM()").first.id}"].sample,
          obj.notes = Faker::Lorem.paragraph
        end

        #ensure_location_information
        data_location = {
          name:   Faker::Name.name + " #{r.id}",
          address: Faker::Address.street_address,
          country: Faker::Address.country,
          country_code: Faker::Address.country_code,
          city: Faker::Address.city,
          state: Faker::Address.state,
          zipcode: Faker::Address.zip_code,
          location_notes: Faker::Lorem.sentence
        }
        edition.location.update(data_location)

        #ensure_financial_information
        data_financial = {
          price: Faker::Number.decimal(2),
          insured_price: Faker::Number.decimal(2),
          insured_type: Faker::Lorem.word,
          policy: Faker::Lorem.paragraph
        }
        edition.financial_information.update(data_financial)

        #ensure_details
        data_details = {
            manufacturer: Faker::Name.name + " #{r.id}",
            designer: Faker::Name.name + " #{r.id}",
            period: Faker::Date.between(200.years.ago, 50.years.ago).strftime("%Y"),
            packaging: Faker::Lorem.word,
            unique_marks: Faker::Lorem.characters(10),
            additional_information: Faker::Lorem.sentence,
            system: ['standard', 'metric'].sample,
            frame: BaseUnitSystem.fake_size
        }
        edition.details.update(data_details)

        #admin
        edition.admin.update(copyright: Faker::Lorem.sentence)

        #appraisals
        [1, 2, 3].sample.times do
          Appraisal.create do |obj|
            obj.financial_information = edition.financial_information
            obj.name = Faker::Lorem.word
            obj.appraisal_price = Faker::Number.decimal(2)
            obj.appraisal_at = Faker::Date.between(120.days.ago, Date.today)
          end
        end
      end
    end

    puts "Edition count = #{Edition.count}"
  end

end
