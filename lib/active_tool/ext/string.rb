class String
  def to_b
    self.unpack("B*").first
  end
  
  def to_type_b
    v = self.to_b
    "#{:string.to_b}#{(v.size/8).to_b}#{v}"
  end
  
  def to_binary
    self.pack("B*").first
  end
  
  def as_buffer
    
  end
end