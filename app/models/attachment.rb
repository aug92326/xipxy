class Attachment < ActiveRecord::Base
  include ActsAs::SharedApi
  belongs_to :attachable, :polymorphic => true

  mount_uploader :file, FileUploader

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :name
    t.add :file_url, as: :file
    t.add :public
    t.add :original_filename, as: :file_name
    t.add lambda{ |attach| attach.file.size rescue nil }, as: :file_size
    t.add :created_at
  end

  def file_url
    absolute_url(self.file.url)
  end

  def self.all_polymorphic_types(name)
    @poly_hash ||= {}.tap do |hash|
      Dir.glob(File.join(Rails.root, "app", "models", "**", "*.rb")).each do |file|
        klass = (File.basename(file, ".rb").camelize.constantize rescue nil)
        next if klass.nil? or !klass.ancestors.include?(ActiveRecord::Base)
        klass.reflect_on_all_associations(:has_many).select{|r| r.options[:as] }.each do |reflection|
          (hash[reflection.options[:as]] ||= []) << klass
        end
      end
    end
    @poly_hash[name.to_sym]
  end
end
