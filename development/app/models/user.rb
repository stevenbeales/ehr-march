class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  def self.roles
    [:Provider, :Patient, :Admin, :Representative]
  end

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

  devise :authy_authenticatable, :database_authenticatable, :registerable, :confirmable, :timeoutable, :recoverable, :rememberable

  has_one :provider,            dependent: :destroy
  has_one :user_patient,        dependent: :destroy, class_name: 'Patient'
  has_one :user_representative, dependent: :destroy, class_name: 'Representative'

  before_validation :generate_captcha, on: [:create]
  after_update  :unlock, if: -> { remember_created_at == nil && locked == true }

  def person
    case role
      when :Provider
        provider
      when :Patient
        user_patient
      when :Admin
        admin
      when :Representative
        user_representative.patient
    end
  end

  def patient
    role == :Patient ? user_patient : user_representative.patient
  end

  def patient?
    role == :Patient || role == :Representative
  end

  def inbox
    EmailMessage.where(to_id: user_id_for_email_messages,  draft: false, archive: false)
  end

  def sent
    EmailMessage.where(from_id: user_id_for_email_messages, draft: false, archive: false)
  end

  def draft
    EmailMessage.where(from_id: user_id_for_email_messages, draft: true, archive: false)
  end

  def urgent
    EmailMessage.where(to_id: user_id_for_email_messages, draft: false, urgent: true, archive: false)
  end

  def archive
    EmailMessage.where(to_id: user_id_for_email_messages, draft: false, archive: true)
  end

  def to_label
    "#{email}"
  end

  def active_for_authentication?
    super && active?
  end

  def active?
    case role
      when :Provider
        provider.practice_role == :Provider ? true : provider.status
      when :Representative
        user_representative.active
      else
        true
    end
  end

  def inactive_message
    'Sorry, this account has been deactivated'
  end

  def user_id_for_email_messages
    role == :Representative ? user_representative.patient.user.id : id
  end

  private

  def generate_captcha
    self.captcha = Activation.code
  end

  def unlock
    update(locked: false)
  end
end
