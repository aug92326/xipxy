class ArtworkManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_artwork(args)
    Artwork.new(args)
  end

  def find(artwork_id)
    artwork = Artwork.find artwork_id
    # ArtworkAuthorization.new(artwork, user).authorize(:access_artwork)
  rescue Pundit::NotAuthorizedError
  end

  def latest
    Artwork.order('created_at DESC')
  end

  def create_artwork(args={})
    args = size_convertor(args)
    artwork = new_artwork(args)
    # ArtworkAuthorization.new(artwork, user).authorize(:access_artwork)
    artwork.save
    #TODO some logic (create news, set accessing_user, etc)

    artwork
  rescue Pundit::NotAuthorizedError
  end

  def update_artwork(artwork_id, args={})
    artwork = find artwork_id
    args = size_convertor(args, false, "size")
    # ArtworkAuthorization.new(artwork, user).authorize(:update_artwork)
    artwork.update(args)
    #TODO some logic (create news, set accessing_user, etc)

    artwork
  rescue Pundit::NotAuthorizedError
  end

  def delete_artwork(artwork_id)
    artwork = find artwork_id
    # ArtworkAuthorization.new(artwork, user).authorize(:delete_artwork)
    artwork.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    artwork
  end

  def update_details(artwork_id, details={})
    artwork = find artwork_id
    details = size_convertor(details, false, "frame")
    artwork_details = artwork.details
    # ArtworkAuthorization.new(artwork, user).authorize(:update_details)
    artwork.details.update(details)

    artwork_details
  end

  def find_version(id)
    ArtworkVersion.find id
    # ArtworkAuthorization.new(artwork, user).authorize(:access_version)
  rescue Pundit::NotAuthorizedError
  end

  def new_version(artwork, args)
    artwork.versions.build(args)
  end

  def versions(artwork_id)
    artwork = find artwork_id
    # ArtworkAuthorization.new(artwork, user).authorize(:access_versions)
    artwork.versions
  end

  def create_version(artwork_id, args={})
    artwork = find artwork_id
    # ArtworkAuthorization.new(artwork, user).authorize(:create_version)
    args = size_convertor(args)
    version = new_version(artwork, args)
    version.save
    #TODO some logic (create news, set accessing_user, etc)

    version
  end

  def update_version(version_id, args={})
    version = find_version version_id
    # ArtworkAuthorization.new(artwork, user).authorize(:update_version)
    args = size_convertor(args, false, "size")
    version.update(args)

    version
  end

  def delete_version(version_id)
    version = find_version version_id
    # ArtworkAuthorization.new(artwork, user).authorize(:delete_version)
    version.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    version
  rescue Pundit::NotAuthorizedError
  end

  private

  def size_convertor(args={}, new=true, type="size")
    sizes = {"depth"=>"0", "width"=>"0", "height"=>"0"}

    if args[type].present?
      args[type] = sizes.merge(args[type])
    else
      args[type] = sizes if new
    end

    args
  end
end