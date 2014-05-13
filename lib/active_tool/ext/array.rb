class Array
  def to_buffer
    if self[:id]
      GameMessage.new(self[:id], self[:data]).to_buffer
    else
      self.to_json
    end
  end
  
  def bs_index(n)
    i = -1
    self.reverse.each_with_index do |v, j|
      i = self.size - j - 1 and break if n >= v
    end
    i
  end
  
  def ls_index(n)
    i = -1
    self.each_with_index do |v, j|
      i = j and break if n <= v
      i = j and break if j == self.size - 1 && n >= v
    end
    i
  end
end