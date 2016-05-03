class ArtistManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_artist(args)
    Artist.new(args)
  end

  def find(artist_id)
    artist = Artist.find artist_id
    # ArtistAuthorization.new(artist, user).authorize(:access_artist)
  rescue Pundit::NotAuthorizedError
  end

  def latest
    Artist.order('created_at DESC')
  end

  def create_artist(args={})
    artist = new_artist(args)
    # ArtistAuthorization.new(artist, user).authorize(:access_artist)
    artist.save
    #TODO some logic (create news, set accessing_user, etc)

    artist
  rescue Pundit::NotAuthorizedError
  end

  def update_artist(artist_id, args={})
    artist = find artist_id
    # ArtistAuthorization.new(artist, user).authorize(:update_artist)
    artist.update(args)
    #TODO some logic (create news, set accessing_user, etc)

    artist
  rescue Pundit::NotAuthorizedError
  end

  def delete_artist(artist_id)
    artist = find artist_id
    # ArtistAuthorization.new(artist, user).authorize(:delete_artist)
    artist.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    artist
  end
end
