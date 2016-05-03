#rake 'db:create_record[user_email, countOf_new_records]'
desc "create records for user"
namespace :db do
  task :create_record, [:email, :records_count] => :environment do |t, args|
    user = User.find_by_email(args[:email])

    args[:records_count].to_i.times do |n|
      data_record = {
        model: Faker::Name.name + " #{n}",
        year: {value: Faker::Date.between(200.years.ago, 50.years.ago).strftime("%Y").to_i, estimated: false},
        material: 'paper',
        system: ['standard', 'metric'].sample,
        weight: BaseUnitSystem.fake_weight,
        duration: {hours: Faker::Number.between(0, 24).to_s, minutes: Faker::Number.between(0, 60).to_s, seconds: Faker::Number.between(0, 60).to_s},
        size: BaseUnitSystem.fake_size
      }

      record = Record.new(data_record)
      record.save

      record.set_owner user

      #ensure_artist
      data_artist = {brand: Faker::Name.name + " #{n}",
                     country: Faker::Address.country,
                     founded: Faker::Date.between(200.years.ago, 50.years.ago).strftime("%Y").to_i,
                     closed: Faker::Date.between(150.years.ago, 1.year.ago).strftime("%Y").to_i}
      artist = record.build_artist data_artist
      artist.save

      #ensure_primary_edition
      data_location = {
        name:   Faker::Name.name + " #{n}",
        address: Faker::Address.street_address,
        country: Faker::Address.country,
        country_code: Faker::Address.country_code,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip_code,
        location_notes: Faker::Lorem.sentence
      }

      data_edition = {
        edition_type: ['Editions', "Artist's Proof", "Printer's Proof"].sample,
        primary_status: ['Owned', "Consigned from #{User.order("RANDOM()").first.id}"].sample,
        secondary_status: ["On Reserve for #{User.order("RANDOM()").first.id}", "Consigned #{User.order("RANDOM()").first.id}"].sample,
        notes: Faker::Lorem.paragraph
      }

      record.primary_edition.update(data_edition)

      record.primary_edition.location.update(data_location)

      edition = record.primary_edition

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
        manufacturer: Faker::Name.name + " #{n}",
        designer: Faker::Name.name + " #{n}",
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
      Appraisal.create do |obj|
        obj.financial_information = edition.financial_information
        obj.name = Faker::Lorem.word
        obj.appraisal_price = Faker::Number.decimal(2)
        obj.appraisal_at = Faker::Date.between(120.days.ago, Date.today)
      end

      image = begin
        fn = "bg#{(9..19).to_a.sample}.jpg"
        File.open(File.join(Rails.root, 'db', 'fixtures', 'images', fn))
      end

      #image
      Image.create do |img|
        img.edition = edition
        img.copyright_holder = Faker::Lorem.sentence
        img.licensing_agency = Faker::Lorem.sentence
        img.primary = true
        img.image = image
        img.resolution = Faker::Lorem.sentence
        img.credit_line = Faker::Lorem.sentence
        img.licensing_fee = Faker::Lorem.sentences.join(' ')
      end
    end

  end
end