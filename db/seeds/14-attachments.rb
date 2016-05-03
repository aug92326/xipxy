module SeedAttachment
  def self.seed
    Attachment.destroy_all
    30.times do
      file = begin
        fn = ['doc.doc', 'pdf.pdf'].sample
        File.open(File.join(Rails.root, 'db', 'fixtures', 'documents', fn))
      end

      attachable = [Appraisal, Edition, FinancialInformation].sample.order("RANDOM()").first
      Attachment.create do |attach|
        attach.name = Faker::Lorem.sentence
        attach.attachable = attachable
        attach.file = file
      end
    end

    puts "Attachment count = #{Attachment.count}"
  end

end
