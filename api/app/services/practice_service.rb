class PracticeService
  def self.create
    current_provider = Provider.first

    Provider.practice_roles[1..-1].each do |role|
      authy_id = Authy::API.register_user(
        email:        Rails.application.secrets.ehr_practice_email,
        cellphone:    Rails.application.secrets.admin_phone_number,
        country_code: Rails.application.secrets.admin_country_code).id

      user = FactoryGirl.create :user,
        email:          "#{role.to_s.downcase}@ehr.com",
        password:       Rails.application.secrets.ehr_practice_password,
        authy_id:       authy_id.to_s,
        authy_enabled:  true

      FactoryGirl.create :provider,
        user_id:        user.id,
        provider_id:    current_provider.id,
        practice_role:  role
    end
  end
end
