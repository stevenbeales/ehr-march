class ChartPolicy < BasePolicy
  def main_show?
    available?
  end

  def dental_show?
    available?
  end

  def perio_show?
    available?
  end

  def profile_show?
    available?
  end

  def perio_update?
    available?
  end

  def insurance_show?
    available?
  end
end
