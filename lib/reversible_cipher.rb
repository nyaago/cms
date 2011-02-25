require "openssl"

# = ReversibleCipher
# 可逆暗号化.opensslを利用した暗号化
module ReversibleCipher
  
  # メッセージの暗号化
  def encrypt(msg, pass, salt = nil, cipher = 'aes-256-cbc')
    enc  = OpenSSL::Cipher::Cipher.new(cipher)
    enc.encrypt
    if salt.nil?
      enc.pkcs5_keyivgen(pass)
    else
      enc.pkcs5_keyivgen(pass, salt)
    end
    enc.update(msg) + enc.final
  end

  # メッセージの複合化
  def decrypt(crypt_msg, pass, salt = nil, cipher = 'aes-256-cbc')
    dec = OpenSSL::Cipher::Cipher.new(cipher)
    dec.decrypt
    if salt.nil?
      dec.pkcs5_keyivgen(pass)
    else
      dec.pkcs5_keyivgen(pass, salt)
    end
    dec.update(crypt_msg)+ dec.final 
  end
  
  # saltの生成
  def salt(byte_count = 8)
    OpenSSL::Random.random_bytes(byte_count)
  end
  
end