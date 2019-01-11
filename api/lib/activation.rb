module Activation
  def self.code(size = 5)
    (0...size).map{ (1..9).to_a.sample }.join
  end

  def self.colour
    SecureRandom.hex(3).upcase
  end
end