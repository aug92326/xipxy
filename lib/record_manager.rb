require 'api_error'
class RecordManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_record(args)
    Record.new(args)
  end

  def find(record_id)
    record = Record.find record_id
    RecordAuthorization.new(record, user).authorize(:access_record)

    record
  rescue
    raise ActionNotAllowedError, "You are not authorized to access this record"
  end

  def latest
    @user.records
  end

  def create_record(args={})
    record = new_record(args.except(*['size', 'weight', 'artist', 'duration']))
    # RecordAuthorization.new(record, user).authorize(:access_record)
    record.size = BaseUnitSystem.size_convertor(record, args) if args['size'].present?
    record.duration = DurationManager.new(record).convertor(args) if args['duration'].present?
    record.weight = BaseUnitSystem.weight_convertor(record, args) if args['weight'].present?

    record.save
    #TODO some logic (create news, set accessing_user, etc)
    #set owner of record
    record.set_owner @user

    if args['artist'].present?
      records_artist = record.build_artist args['artist']
      records_artist.save
    end

    record
  rescue Pundit::NotAuthorizedError
  end

  def update_record(record_id, args={})
    record = find record_id
    # RecordAuthorization.new(record, user).authorize(:update_record)
    if args['artist'].present?
      records_artist = record.artist
      records_artist.update(args['artist'])
      args.except!('artist')
    end

    record.update(args.except(*['size', 'weight', 'duration']))
    record.size = BaseUnitSystem.size_convertor(record, args) if args['size'].present?
    record.weight = BaseUnitSystem.weight_convertor(record, args) if args['weight'].present?
    record.duration = DurationManager.new(record).convertor(args) if args['duration'].present?
    record.save
    #TODO some logic (create news, set accessing_user, etc)

    record
  rescue Pundit::NotAuthorizedError
  end

  def delete_record(record_id)
    record = find record_id
    # RecordAuthorization.new(record, user).authorize(:delete_record)
    record.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    record
  end

##################################

  def find_multiple_object(id)
    ArtworkMultipleObject.find id
      # RecordAuthorization.new(record, user).authorize(:access_multiple_object)
  rescue Pundit::NotAuthorizedError
  end

  def new_multiple_object(record, args)
    record.multiple_objects.build(args)
  end

  def multiple_objects(records_id)
    record = find records_id
    # RecordAuthorization.new(record, user).authorize(:access_multiple_objects)
    record.multiple_objects
  end

  def create_multiple_object(record_id, args={})
    record = find record_id
    # RecordAuthorization.new(record, user).authorize(:create_multiple_object)
    multiple_object = new_multiple_object(record, args.except(*['size', 'weight', 'duration']))
    multiple_object.size = BaseUnitSystem.size_convertor(multiple_object, args) if args['size'].present?
    multiple_object.duration = DurationManager.new(multiple_object).convertor(args) if args['duration'].present?
    multiple_object.weight = BaseUnitSystem.weight_convertor(multiple_object, args) if args['weight'].present?

    multiple_object.save
    #TODO some logic (create news, set accessing_user, etc)

    multiple_object
  end

  def update_multiple_object(multiple_object_id, args={})
    multiple_object = find_multiple_object multiple_object_id
    # RecordAuthorization.new(record, user).authorize(:update_multiple_object)
    multiple_object.update(args.except(*['size', 'weight', 'duration']))
    multiple_object.duration = DurationManager.new(multiple_object).convertor(args) if args['duration'].present?
    multiple_object.size = BaseUnitSystem.size_convertor(multiple_object, args) if args['size'].present?
    multiple_object.weight = BaseUnitSystem.weight_convertor(multiple_object, args) if args['weight'].present?
    multiple_object.save

    multiple_object
  end

  def delete_multiple_object(multiple_object_id)
    multiple_object = find_multiple_object multiple_object_id
    # RecordAuthorization.new(record, user).authorize(:delete_multiple_object)
    multiple_object.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    multiple_object
  rescue Pundit::NotAuthorizedError
  end

##################################

  def find_edition(id)
    Edition.find id
      # RecordAuthorization.new(record, user).authorize(:access_edition)
  rescue Pundit::NotAuthorizedError
  end

  def new_edition(record, args)
    record.editions.build(args)
  end

  def editions(records_id)
    record = find records_id
    # RecordAuthorization.new(record, user).authorize(:access_editions)
    record.editions
  end

  def create_edition(record_id, args={})
    record = find record_id
    # RecordAuthorization.new(record, user).authorize(:create_edition)
    edition = new_edition(record, args)
    edition.save
    #TODO some logic (create news, set accessing_user, etc)

    edition
  end

  def clone_primary_edition(record_id, args={})
    record = find record_id
    # RecordAuthorization.new(record, user).authorize(:create_edition)
    primary_edition = record.primary_edition
    edition = primary_edition.deep_clone :include => [:details, {financial_information: [:appraisals]}, :exhibition_histories, :ownerships, :publications, :tags, :location, :admin]
    #edition.attributes args

    #need add location
    #TODO add attachments if need

    edition.is_from_primary = true
    edition.primary = false
    edition.save

    edition
  end

  def update_edition(edition_id, args={})
    edition = find_edition edition_id
    # RecordAuthorization.new(record, user).authorize(:update_edition)

    if args['financial_information'].present?
      financial_information = edition.financial_information
      financial_information.update(args['financial_information'])
      args.except!('financial_information')
    end

    if args['location'].present?
      location = edition.location
      location.update(args['location'])
      args.except!('location')
    end

    #patch for details
    if args['details'].present?
      details = edition.details
      details.update(args['details'].except('frame'))
      if args['details']['frame'].present?
        details.frame = BaseUnitSystem.size_convertor(details, args['details'], 'frame')
        details.save
      end
      args.except!('details')
    end

    if args['admin'].present?
      edition_admin = edition.admin
      edition_admin.update(args['admin'])
      args.except!('admin')
    end

    edition.update(args)

    edition
  end

  def delete_edition(edition_id)
    edition = find_edition edition_id
    # EditionAuthorization.new(record, user).authorize(:delete_edition)
    edition.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    edition
  rescue Pundit::NotAuthorizedError
  end

##################################
  def find_image(id)
    Image.find id
      # RecordAuthorization.new(record, user).authorize(:access_image)
  rescue Pundit::NotAuthorizedError
  end

  def new_image(edition, args)
    edition.images.build(args)
  end

  def images(edition_id)
    edition = find_edition edition_id
    # RecordAuthorization.new(record, user).authorize(:access_images)
    edition.images
  end

  def create_image(edition_id, args={})
    edition = find_edition edition_id
    # RecordAuthorization.new(record, user).authorize(:create_image)
    images = edition.images
    image = new_image(edition, args)
    if images.blank?
      image.primary = true
    else
      images.where(primary: true).update_all(primary: false) if args[:primary]
    end
    image.save
    #TODO some logic (create news, set accessing_user, etc)

    image
  end

  def update_image(image_id, args={})
    image = find_image image_id
    # RecordAuthorization.new(record, user).authorize(:update_image)
    edition = image.edition
    images = edition.images.where.not(id: image_id)
    if images.blank?
      args[:primary] = true
    else
      if args[:primary]
        images.where(primary: true).update_all(primary: false)
      else
        images[0].update(primary: true) if image.primary || images.where(primary: true).blank?
      end
    end

    image.update(args)

    image
  end

  def delete_image(image_id)
    image = find_image image_id
    image_was_primary = image.primary
    edition = image.edition
    # RecordAuthorization.new(record, user).authorize(:delete_image)
    image.destroy!
    images = edition.images
    images[0].update(primary: true) if image_was_primary && images.present?
    #TODO some logic (create news, set accessing_user, etc)

    image
  rescue Pundit::NotAuthorizedError
  end

##################################

##################################
  def find_file(id)
    Document.find id
      # RecordAuthorization.new(record, user).authorize(:access_file)
  rescue Pundit::NotAuthorizedError
  end

  def new_file(edition, args)
    edition.documents.build(args)
  end

  def files(edition_id)
    edition = find_edition edition_id
    # RecordAuthorization.new(record, user).authorize(:access_files)
    edition.documents
  end

  def create_file(edition_id, args={})
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:create_file)
    file = new_file(edition, args)
    file.save
    #TODO some logic (create news, set accessing_user, etc)

    file
  end

  def update_file(file_id, args={})
    file = find_file file_id
    # RecordAuthorization.new(record, user).authorize(:update_file)
    file.update(args)

    file
  end

  def delete_file(file_id)
    file = find_file file_id
    # RecordAuthorization.new(record, user).authorize(:delete_file)
    file.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    file
  rescue Pundit::NotAuthorizedError
  end

end