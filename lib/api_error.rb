class ApiError < StandardError; end
class BaseError < Pundit::NotAuthorizedError
  def initialize(msg=nil)
    super(msg || 'You are not authorized to access this event')
  end
end
class ActionNotAllowedError < BaseError; end
class ChangeSelfRoleError < BaseError; end
