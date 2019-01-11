class AdminService

  def self.create
    authy_id = Authy::API.register_user(
      email:        Rails.application.secrets.admin_email,
      cellphone:    Rails.application.secrets.admin_phone_number,
      country_code: Rails.application.secrets.admin_country_code).id

    FactoryGirl.create :user,
      role:           :Admin,
      email:          Rails.application.secrets.admin_email,
      password:       Rails.application.secrets.admin_password,
      authy_id:       authy_id.to_s,
      authy_enabled:  true
  end
end
