class AdminPolicy < BasePolicy
  def admin?
    current_user.role == :Admin
  end
end
