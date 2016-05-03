class Document < ActiveRecord::Base
  include ActsAs::SharedApi

  belongs_to :edition, touch: true

  mount_uploader :file, FileUploader

  api_accessible :light do |t|
    t.add :id
  end

  api_accessible :basic do |t|
    t.add :id
    t.add :edition_id
    t.add :title
    t.add :public
    t.add :file_url, as: :file
    t.add :original_filename, as: :file_name
    t.add lambda{ |doc| doc.file.size rescue nil }, as: :file_size
    t.add :created_at
  end

  def file_url
    absolute_url(self.file.url)
  end
end
