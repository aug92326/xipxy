module DeviseRegistrationOverrides
  extend ActiveSupport::Concern

  # included do
  #   def build_resource(hash=nil)
  #     self.resource = resource_class.new_with_session(hash || {}, session)
  #     if !hash.empty? && hash['profile_attributes'].present?
  #       self.resource.username = hash['profile_attributes']['full_name'].downcase.split.join
  #     end
  #   end
  # end
end
