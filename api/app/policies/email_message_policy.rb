class EmailMessagePolicy < BasePolicy

  def create?
    if current_user.role == :Patient
      true
    else
      available?
    end
  end

  def show?
    if current_user.role == :Patient
      true
    else
      available?
    end
  end
end
