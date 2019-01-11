class DiagnosisPolicy < BasePolicy
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
