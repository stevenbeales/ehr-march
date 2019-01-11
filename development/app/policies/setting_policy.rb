class SettingPolicy < BasePolicy
  def show?
    available?
  end

  def schedule?
    available?
  end
end
