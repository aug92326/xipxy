class CollectionManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_collection(args)
    RecordsCollection.new(args)
  end

  def find(collection_id)
    collection = RecordsCollection.find collection_id
    # ArtworkAuthorization.new(artwork, user).authorize(:access_artwork)
  rescue Pundit::NotAuthorizedError
  end

  def collections
    @user.collections.order('created_at DESC')
  end

  def create_collection(args={})
    collection = new_collection(args)
    # ArtworkAuthorization.new(artwork, user).authorize(:access_artwork)
    collection.save
    #TODO some logic (create news, set accessing_user, etc)

    collection
  rescue Pundit::NotAuthorizedError
  end

  def update_collection(collection_id, args={})
    collection = find collection_id
    # ArtworkAuthorization.new(artwork, user).authorize(:update_artwork)
    collection.update(args)
    #TODO some logic (create news, set accessing_user, etc)

    collection
  rescue Pundit::NotAuthorizedError
  end

  def delete_collection(collection_id)
    collection = find collection_id
    # ArtworkAuthorization.new(artwork, user).authorize(:delete_artwork)
    collection.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    collection
  end

  def add_record_to_collection(collection_id, record_id)
    collection = find collection_id
    collection.collections_lists.find_or_create_by(record_id)

    find collection_id
  end

  def remove_record_from_collection(collection_id, record_id)
    collection = find collection_id
    collection.collections_lists.find_by_record_id(record_id).delete

    find collection_id
  end
end