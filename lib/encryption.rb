require 'openssl'
require 'digest'
require 'base64'

class TextCrypto
  def self.encrypt(text, key)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = Digest::SHA256.digest(key)
    iv = cipher.random_iv
    cipher.iv = iv

    encrypted = cipher.update(text) + cipher.final
    Base64.encode64(iv + encrypted)
  end

  def self.decrypt(base64_input, key)
    decipher = OpenSSL::Cipher.new('AES-256-CBC')
    decipher.decrypt
    decipher.key = Digest::SHA256.digest(key)
    raw = Base64.decode64(base64_input)
    iv = raw[0..15]
    encrypted = raw[16..-1]
    decipher.iv = iv

    decipher.update(encrypted) + decipher.final
  rescue => e
    "❌ ERROR: Decryption failed. Check key or input."
  end
end
