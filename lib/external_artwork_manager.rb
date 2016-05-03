class ExternalArtworkManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def find(artwork_id)
    ExternalArtwork.find artwork_id
    # ExternalArtworkAuthorization.new(artwork, user).authorize(:access_artwork)
  rescue Pundit::NotAuthorizedError
  end

  def latest(artist_id)
    if artist_id.present?
      ExternalArtwork.where(artist_id: artist_id)
    else
      ExternalArtwork
    end
    .order('created_at DESC')
  end
end