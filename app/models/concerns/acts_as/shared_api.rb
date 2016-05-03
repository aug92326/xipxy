module ActsAs
  module SharedApi
    extend ActiveSupport::Concern
    included do
      acts_as_api

      api_accessible :errors do |t|
        t.add :error_messages, as: :errors
      end
    end

    def error_messages
      self.errors.full_messages.uniq
    end

  end
end
