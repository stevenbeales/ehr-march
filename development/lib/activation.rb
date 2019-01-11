module Activation
  def self.code(size = 5)
    charset = %w{ 1 2 3 4 5 6 7 8 9 }
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  def self.colour
    SecureRandom.hex(3).upcase
  end
end