module API
  module V1
    class Root < Grape::API
      version 'v1'
      use API::Concern::ApiLogger
      include API::Concern::Status
      include API::Concern::Registration
      include API::Concern::Session
      include API::Concern::Password
      before do
        authenticate_user! unless request.path =~ /v1\/swagger_doc*/
      end
      include API::Concern::UserProfile
      include API::Concern::Artists
      include API::Concern::Locations
      include API::Concern::ExternalArtworks
      include API::Concern::Attachments
      include API::Concern::RecordsSearch
      include API::Concern::Records
      include API::Concern::RecordsMultipleObjects
      include API::Concern::RecordsEditions
      include API::Concern::EditionsImages
      include API::Concern::EditionsDocuments
      include API::Concern::EditionsFinancialInformation
      include API::Concern::Appraisals
      include API::Concern::EditionsExhibitionHistories
      include API::Concern::PriorOwnerships
      include API::Concern::Publications
      include API::Concern::Tags
      include API::Concern::Collections

      add_swagger_documentation(
        base_path: "/api",
        hide_documentation_path: true,
        api_version: 'v1'
      )
    end
  end
end
