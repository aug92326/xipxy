class EditionManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def find(edition_id)
    edition = Edition.find edition_id
    # EditionAuthorization.new(edition, user).authorize(:access_edition)
  rescue Pundit::NotAuthorizedError
  end

  def find_exhibition_history(id)
    ExhibitionHistory.find id
      # EditionAuthorization.new(edition, user).authorize(:access_exhibition_history)
  rescue Pundit::NotAuthorizedError
  end

  def new_exhibition_history(edition, args)
    edition.exhibition_histories.build(args)
  end

  def exhibition_histories(edition_id)
    edition = find edition_id
    # EditionAuthorization.new(edition, user).authorize(:access_exhibition_histories)
    edition.exhibition_histories
  end

  def create_exhibition_history(edition_id, args={})
    edition = find edition_id
    # EditionAuthorization.new(edition, user).authorize(:create_exhibition_history)
    exhibition_history = new_exhibition_history(edition, args)
    exhibition_history.save
    #TODO some logic (create news, set accessing_user, etc)

    exhibition_history
  end

  def update_exhibition_history(exhibition_history_id, args={})
    exhibition_history = find_exhibition_history exhibition_history_id
    # EditionAuthorization.new(edition, user).authorize(:update_exhibition_history)
    exhibition_history.update(args)

    exhibition_history
  end

  def delete_exhibition_history(exhibition_history_id)
    exhibition_history = find_exhibition_history exhibition_history_id
    # EditionAuthorization.new(edition, user).authorize(:delete_exhibition_history)
    exhibition_history.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    exhibition_history
  rescue Pundit::NotAuthorizedError
  end

  #####################
  def find_financial_information(edition_id)
    edition = find edition_id
    edition.financial_information
      # EditionAuthorization.new(edition, user).authorize(:access_financial_information)
  rescue Pundit::NotAuthorizedError
  end

  def update_financial_information(edition_id, args={})
    edition = find edition_id
    # RecordAuthorization.new(edition, user).authorize(:update_edition)
    #patch for details
    edition.financial_information.update(args)
    #TODO some logic (create news, set accessing_user, etc)

    edition
  end

  ##################################
  def find_appraisal(id)
    Appraisal.find id
      # RecordAuthorization.new(record, user).authorize(:access_appraisal)
  rescue Pundit::NotAuthorizedError
  end

  def new_appraisal(edition, args)
    edition.financial_information.appraisals.build(args)
  end

  def appraisals(edition_id)
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:access_appraisals)
    edition.appraisals
  end

  def create_appraisal(edition_id, args={})
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:create_appraisal)
    appraisal = new_appraisal(edition, args)
    appraisal.save
    #TODO some logic (create news, set accessing_user, etc)

    appraisal
  end

  def update_appraisal(appraisal_id, args={})
    appraisal = find_appraisal appraisal_id
    # RecordAuthorization.new(record, user).authorize(:update_appraisal)
    appraisal.update(args)

    appraisal
  end

  def delete_appraisal(appraisal_id)
    appraisal = find_appraisal appraisal_id
    # RecordAuthorization.new(record, user).authorize(:delete_appraisal)
    appraisal.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    appraisal
  rescue Pundit::NotAuthorizedError
  end

##################################

  ##################################
  def find_ownership(id)
    PriorOwnership.find id
      # RecordAuthorization.new(record, user).authorize(:access_ownership)
  rescue Pundit::NotAuthorizedError
  end

  def new_ownership(edition, args)
    edition.ownerships.build(args)
  end

  def ownerships(edition_id)
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:access_ownerships)
    edition.ownerships
  end

  def create_ownership(edition_id, args={})
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:create_ownership)
    ownership = new_ownership(edition, args)
    ownership.save
    #TODO some logic (create news, set accessing_user, etc)

    ownership
  end

  def update_ownership(ownership_id, args={})
    ownership = find_ownership ownership_id
    # RecordAuthorization.new(record, user).authorize(:update_ownership)
    ownership.update(args)

    ownership
  end

  def delete_ownership(ownership_id)
    ownership = find_ownership ownership_id
    # RecordAuthorization.new(record, user).authorize(:delete_ownership)
    ownership.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    ownership
  rescue Pundit::NotAuthorizedError
  end

##################################
##################################
  def find_publication(id)
    Publication.find id
      # RecordAuthorization.new(record, user).authorize(:access_publication)
  rescue Pundit::NotAuthorizedError
  end

  def new_publication(edition, args)
    edition.publications.build(args)
  end

  def publications(edition_id)
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:access_publications)
    edition.publications
  end

  def create_publication(edition_id, args={})
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:create_publication)
    publication = new_publication(edition, args)
    publication.save
    #TODO some logic (create news, set accessing_user, etc)

    publication
  end

  def update_publication(publication_id, args={})
    publication = find_publication publication_id
    # RecordAuthorization.new(record, user).authorize(:update_publication)
    publication.update(args)

    publication
  end

  def delete_publication(publication_id)
    publication = find_publication publication_id
    # RecordAuthorization.new(record, user).authorize(:delete_publication)
    publication.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    publication
  rescue Pundit::NotAuthorizedError
  end

##################################

##################################
  def find_tag(id)
    Tag.find id
      # RecordAuthorization.new(record, user).authorize(:access_tag)
  rescue Pundit::NotAuthorizedError
  end

  def new_tag(edition, args)
    edition.tags.build(args)
  end

  def tags(edition_id)
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:access_tags)
    edition.tags
  end

  def create_tag(edition_id, args={})
    edition = find edition_id
    # RecordAuthorization.new(record, user).authorize(:create_tag)
    tag = new_tag(edition, args)
    tag.save
    #TODO some logic (create news, set accessing_user, etc)

    tag
  end

  def update_tag(tag_id, args={})
    tag = find_tag tag_id
    # RecordAuthorization.new(record, user).authorize(:update_tag)
    tag.update(args)

    tag
  end

  def delete_tag(tag_id)
    tag = find_tag tag_id
    # RecordAuthorization.new(record, user).authorize(:delete_tag)
    tag.destroy!
    #TODO some logic (create news, set accessing_user, etc)

    tag
  rescue Pundit::NotAuthorizedError
  end

##################################

end