class ProfilePolicy < BasePolicy
  def show?
    available?
  end

  def update?
    available?
  end
end
