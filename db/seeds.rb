puts "Seeding data"

def load_rb(seed)
  require 'yaml'
  puts "#{Time.now} | Execute seed #{seed.inspect}"
  require "#{seed}"
  klass_name = ("seed_" + File.basename("#{seed}", '.rb').split('-').last).classify
  klass = klass_name.constantize
  klass.send(:seed)
end

if ENV['SEED_FILES'].present?
  seed_files = ENV['SEED_FILES'].split(',')
  seed_files.each do |seed_name|
    load_rb("#{Rails.root}/db/seeds/#{seed_name}.rb")
  end
else
  Dir["#{Rails.root}/db/seeds/*.rb"].sort.each do |seed|
    load_rb(seed)
  end
end

puts "Done!"