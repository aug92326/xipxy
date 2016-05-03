class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :token_authenticatable,
         :password_expirable, :session_limitable

  belongs_to :unit_system, :class_name => 'BaseUnitSystem', :foreign_key => 'unit_system_id'
  has_one :profile, class_name: UserProfile, foreign_key: :user_id
  has_and_belongs_to_many :records
  has_many :locations, class_name: 'Location', through: :records, source: :locations
  has_many :collections, class_name: 'RecordsCollection', foreign_key: :user_id, dependent: :destroy

  attr_accessor :login

  include ActsAs::SharedApi

  acts_as_api

  api_accessible :basic do |t|
    t.add :id
    t.add :email
    t.add :username
    t.add :created_at
  end

  api_accessible :default_token, extend: :basic do |t|
    t.add :authentication_token, as: :access_token
  end

  api_accessible :my_profile_mode, extend: :default_token do |t|
    t.add :sign_in_count
    t.add :current_sign_in_at
    t.add :current_sign_in_ip
    t.add :confirmed_at
    t.add lambda{ |usr| usr.profile.as_api_response(:basic) rescue nil }, as: :profile
  end

  before_create :ensure_authentication_token, :ensure_username
  after_create :ensure_profile

  class << self
    def authenticate(email_or_username, password)
      user = where(["lower(username) = :value OR lower(email) = :value", { :value => email_or_username.downcase }]).first
      return nil unless user
      unless user.valid_password?(password)
        sign_in_attributes = {
            failed_attempts: user.failed_attempts.to_i + 1
        }
        user.update_columns(sign_in_attributes)
        user.lock_access! if user.failed_attempts >= Devise.maximum_attempts
        return nil
      end
      user.unlock_access! if user.access_locked? && user.locked_at < Devise.unlock_in.ago
      user
    end

    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
  end

  def signed_in!(request)
    update_columns(
      current_sign_in_ip: request.env['REMOTE_ADDR'],
      current_sign_in_at: DateTime.now,
      last_sign_in_at: DateTime.now,
      last_sign_in_ip: request.env['REMOTE_ADDR'],
      sign_in_count: (sign_in_count.to_i + 1)
    )
  end

  def validate_request!(request, params)
    if access_locked?
      errors.add(:account,'is locked please contact us')
    elsif !confirmed?
      errors.add(:email,'is not confirmed yet')
    elsif timedout?(current_sign_in_at)
      errors.add(:session, 'expired. Please make re-login.')
    else
      signed_in! request
    end
  end

  def system_of_units
    "UnitSystem::#{system_of_units_label}".constantize
  end

  def system_of_units_label
    unit_system.try(:label) || UnitSystem::DEFAULT
  end
  alias system_of_units_code system_of_units_label

  def system_of_units_code= units_code_label
    self.unit_system = BaseUnitSystem.where(label: units_code_label).first
  end

  private

  def ensure_username
    if valid?
      self.username = self.email.split('@')[0] + Devise.friendly_token[0,5].gsub('-', '').downcase
    end

    true
  end

  def ensure_profile
    create_profile
  end
end
