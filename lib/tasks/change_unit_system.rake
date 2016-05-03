desc "update unit labels"
namespace :db do
  task :update_units => :environment do
    BaseUnitSystem.all.each do |system|
      old = system.label
      new = old == 'EU' ? 'METRIC' : 'STANDARD'
      system.label = new
      system.save!
    end
  end
end