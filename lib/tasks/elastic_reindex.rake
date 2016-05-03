namespace :elasticsearch do
  task :reindex => :environment do
    index_name = Record.index_name
    Record.__elasticsearch__.create_index! force: true
    Record.all.find_in_batches(batch_size: 1000) do |group|
      group_for_bulk = group.map do |a|
        { index: { _id: a.id, data: a.as_indexed_json } }
      end
      Record.__elasticsearch__.client.bulk(
          index: index_name,
          type: "record",
          body: group_for_bulk
      )
    end
  end
end