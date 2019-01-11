module AvailableChecker

  private

  def available?(roles = @current_user.try(:provider) ? @current_user.provider.all_permissions.where(policy_name: "#{self.class.name}##{caller[0][/`([^']*)'/, 1]}").first.availabilities.where(available: true).map(&:role) : [], doctor = @current_user.try(:provider))
    return false if @current_user.role != :Provider
    return true if doctor.practice_role == :Provider || (roles.include? 'Admin' && doctor.admin?)
    roles.include? doctor.practice_role.to_s
  end
end