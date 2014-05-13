class Hash
  def >=(h)
    self.keys.map do |key|
      return false if self[key] < (h[key] || 0)
    end
    
    true
  end
  
  def <(h)
    h >= self
  end
  
  def +(h)
    result = {}
    (self.keys | h.keys).map do |key|
      result[key] = self[key].to_i + h[key].to_i
    end
    result
  end
  
  def invalid?
    self.values.map do |value|
      return true if value < 0
    end
    
    false
  end
  
  def to_buffer
    if self[:id]
      GameMessage.new(self[:id], self[:data]).to_buffer
    else
      self.to_json
    end
  end
end