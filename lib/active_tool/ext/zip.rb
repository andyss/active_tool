require 'openssl'
require 'base64'

module DesCoder
  KEY = "zsdf123420!@*^&$qwerjweqjfkleaasdfasdfajsdkf ljaskdlfjaksldfjaklsdfjaklsdfjaksdlfasjdkfljaskdlfjaksldfjasd"
  IV = "zsdf123420!@*^&$qwerjweqjfkleaasdfasdfajsdkf!@*^&$qwerjweqjfklea"
  CIPHER = "des-ede3-cbc"
  URI_UNSAFE = '+/'

  def self.encode(source)
    return URI.encode(Base64.encode64(process(source , true)) , URI_UNSAFE).strip.tr_s("=" , "").tr_s("%" , "_")
  end

  def self.decode(source)
    return process(Base64.decode64(URI.decode(source.tr_s("_" , "%")) + "=") , false)
  end
  
private
  def self.process(str, is_encode)
    c = OpenSSL::Cipher::Cipher.new(CIPHER)
    c.key = KEY
    c.iv = IV
    is_encode ? c.encrypt : c.decrypt
    ret = c.update(str.to_s)
    ret << c.final
  end
end


class String
  # def zip
  #   puts "Input size: #{self.size}"
  #   buf = LZO.compress(self, 3)
  #   puts "Compressed size: #{buf.size}"
  #   
  #   buf
  # end
  
  def encode_des
    DesCoder.encode(self)
  end
  
  def decode_des
    DesCoder.decode(self)
  end
  
  # def unzip
  #   LZO.decompress(self)
  # end
end