class AttachmentManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_attachment(args)
    ActiveRecord::Base::Attachment.new(args)
  end

  def find(attachment_id)
    attachment = ActiveRecord::Base::Attachment.find attachment_id
    # AttachmentAuthorization.new(attachment, user).authorize(:access_attachment)
  rescue Pundit::NotAuthorizedError
  end

  def latest(type, id)
    ActiveRecord::Base::Attachment.where(attachable_type: type, attachable_type: id).order('created_at DESC')
  end

  def create_attachment(args={})
    attachment = new_attachment(args.merge!({user_id: @user.id}))
    # AttachmentAuthorization.new(attachment, user).authorize(:access_attachment)
    attachment.save
    #TODO some logic (create news, set accessing_user, etc)

    attachment
  rescue Pundit::NotAuthorizedError
  end

  def update_attachment(attachment_id, args={})
    attachment = find attachment_id
    # AttachmentAuthorization.new(attachment, user).authorize(:update_attachment)
    attachment.update(args)
    #TODO some logic (create news, set accessing_user, etc)

    attachment
  rescue Pundit::NotAuthorizedError
  end

  def delete_attachment(attachment_id)
    attachment = find attachment_id
    # AttachmentAuthorization.new(attachment, user).authorize(:delete_attachment)
    attachment.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    attachment
  end
end
