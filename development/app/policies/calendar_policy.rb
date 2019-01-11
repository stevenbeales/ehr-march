class CalendarPolicy < BasePolicy
  def show?
    available?
  end
end