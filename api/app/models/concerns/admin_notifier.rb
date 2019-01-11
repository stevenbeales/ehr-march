module AdminNotifier
  def self.included(base)
    base.class_eval do
      after_create  :notify_admin_on_create
      after_update  :notify_admin_on_update
      after_destroy :notify_admin_on_destroy
    end
  end

  def notify_admin_on_create
    notify_admin("New #{self.class.name.downcase} #{full_name} was created")
  end

  def notify_admin_on_update
    notify_admin("#{self.class.name.downcase.capitalize} #{full_name} was updated")
  end

  def notify_admin_on_destroy
    notify_admin("#{self.class.name.downcase.capitalize} #{full_name} was destroyed")
  end

  def notify_admin(body)
    full_phone_number = Rails.application.secrets.admin_country_code + Rails.application.secrets.admin_phone_number
    TextMessage.create(to: full_phone_number, body: body)
    AdminNotifierMailer.notify(body).deliver_now
  end
end