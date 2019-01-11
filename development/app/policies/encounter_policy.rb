class EncounterPolicy < BasePolicy
  def create?
    available?
  end

  def update?
    available?
  end

  def show?
    available?
  end
end
