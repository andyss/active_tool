class Fixnum
  def bits
    (([Math.log(self.abs+1, 2), 8].max)/8.0).ceil * 8
  end
  
  def to_b
    if self >= 0
      self.to_s(2).rjust(self.bits, "0")
    else
      xx = self.abs.to_s(2).rjust(self.bits, "0")
      xx[0] = "1"
      p xx
      xx
    end
  end
  
  def to_double_b
    self.to_s(2).rjust(16, "0")
  end
  
  def to_int_b
    if self >= 0
      self.to_s(2).rjust(32, "0")
    else
      xx = self.abs.to_s(2).rjust(32, "0")
      xx[0] = "1"
      xx
    end
  end
end