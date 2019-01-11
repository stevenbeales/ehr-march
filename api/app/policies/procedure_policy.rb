class ProcedurePolicy < BasePolicy

  def create?
    available?
  end

  def show?
    available?
  end

  def update?
    available?
  end
end
