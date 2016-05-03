desc "migrate_docs_to_attach"
namespace :db do
  task :migrate_docs_to_attach => :environment do
    Document.all.each do |doc|
      attach = Attachment.create(name: doc.title, attachable: doc.edition)
      path_to_doc = ''
      attach.image = File.new(File.join(Rails.root, '/public' + doc.file.url))
      attach.save!

      attach.file.recreate_versions!
    end
  end
end