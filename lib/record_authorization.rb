require 'api_error'
class RecordAuthorization

  def initialize(record, user)
    @user = user
    @record = record
    @members = record.users
  end

  def authorize action
    raise unless self.send action
  end

  def access_record
    @members.include? @user
  end
end