class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.roles
    [:Provider, :Patient, :Admin]
  end

  has_one :provider, dependent: :destroy
  has_one :patient,  dependent: :destroy

  field :email,                   type: String,      uniq: true
  field :encrypted_password,      type: String
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time
  field :remember_created_at,     type: Time
  field :sign_in_count,           type: Integer
  field :current_sign_in_at,      type: Time
  field :last_sign_in_at,         type: Time
  field :current_sign_in_ip,      type: String
  field :last_sign_in_ip,         type: String
  field :role,                    type: Enum,         in: self.roles, default: :Provider
  field :username,                type: String
  field :captcha,                 type: Integer
  field :locked,                  type: Boolean
  field :confirmation_token,      type: String
  field :confirmed_at,            type: Time
  field :confirmation_sent_at,    type: Time
  field :unconfirmed_email,       type: String
  field :authy_id,                type: String
  field :last_sign_in_with_authy, type: Time
  field :authy_enabled,           type: Boolean
  field :auth_token,              type: String,       uniq: true

  devise :authy_authenticatable, :database_authenticatable, :registerable, :confirmable, :timeoutable, :recoverable

  before_create :generate_authentication_token!
  after_update  :unlock, if: -> { remember_created_at == nil && locked == true }

  def generate_authentication_token!
    loop do
      self.auth_token = SecureRandom.hex
      break unless User.where(auth_token: auth_token).first.present?
    end
  end

  def person
    case role
      when :Provider
        provider
      when :Patient
        patient
      when :Admin
        admin
    end
  end

  def inbox
    EmailMessage.where(to_id: id,  draft: false, archive: false)
  end

  def sent
    EmailMessage.where(from_id: id, draft: false, archive: false)
  end

  def draft
    EmailMessage.where(from_id: id, draft: true, archive: false)
  end

  def urgent
    EmailMessage.where(to_id: id, draft: false, urgent: true, archive: false)
  end

  def archive
    EmailMessage.where(to_id: id, draft: false, archive: true)
  end

  def to_label
    "#{email}"
  end

  def active_for_authentication?
    super && (self.role == :Provider && self.provider.practice_role != :Provider ? self.provider.status : true)
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end

  private

  def generate_captcha
    self.captcha = Activation.code
  end

  def unlock
    update(locked: false)
  end
end
