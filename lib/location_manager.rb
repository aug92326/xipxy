class LocationManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_location(args)
    Location.new(args)
  end

  def find(location_id)
    location = Location.find location_id
    # LocationAuthorization.new(location, user).authorize(:access_location)
  rescue Pundit::NotAuthorizedError
  end

  def latest
    @user.locations
  end

  def create_location(args={})
    location = new_location(args.merge!({user_id: @user.id}))
    # LocationAuthorization.new(location, user).authorize(:access_location)
    location.save
    #TODO some logic (create news, set accessing_user, etc)

    location
  rescue Pundit::NotAuthorizedError
  end

  def update_location(location_id, args={})
    location = find location_id
    # LocationAuthorization.new(location, user).authorize(:update_location)
    location.update(args.merge!({user_id: @user.id}))
    #TODO some logic (create news, set accessing_user, etc)

    location
  rescue Pundit::NotAuthorizedError
  end

  def delete_location(location_id)
    location = find location_id
    # LocationAuthorization.new(location, user).authorize(:delete_location)
    location.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    location
  end
end
