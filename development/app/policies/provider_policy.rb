class ProviderPolicy < BasePolicy
  def provider?
    current_user.role == :Provider
  end

  def admin?
    available?([:Admin])
  end
end
