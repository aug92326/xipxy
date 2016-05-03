module Routes
  def root_path
    '/'
  end

  def registration_path
    '/registration'
  end

  def forgot_password_path
    '/forgot_password'
  end

  def app_show_record_path record
    "/#/record/view/#{record.id}"
  end
end