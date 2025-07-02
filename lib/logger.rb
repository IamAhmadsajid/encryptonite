require 'openssl'
require 'digest'
require 'base64'

class Logger
  LOG_PATH = 'logs/activity.log.enc'
  LOG_KEY = Digest::SHA256.digest("this_is_a_local_secret")  # Use same string always
  LOG_IV = "\x00" * 16  # Use fixed 16-byte IV to ensure successful decryption

  def self.encrypt(text)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = LOG_KEY
    cipher.iv = LOG_IV
    encrypted = cipher.update(text) + cipher.final
    Base64.encode64(encrypted)
  end

  def self.decrypt(text)
    decipher = OpenSSL::Cipher.new('AES-256-CBC')
    decipher.decrypt
    decipher.key = LOG_KEY
    decipher.iv = LOG_IV
    raw = Base64.decode64(text)
    decipher.update(raw) + decipher.final
  rescue => e
    "❌ Failed to read logs: #{e.message}"
  end

  def self.log(action, details)
    Dir.mkdir("logs") unless Dir.exist?("logs")
    log_entry = "[#{Time.now}] #{action.upcase} -> #{details}\n"

    previous_logs = File.exist?(LOG_PATH) ? decrypt(File.read(LOG_PATH)) : ""
    updated_logs = previous_logs + log_entry
    File.write(LOG_PATH, encrypt(updated_logs))
  end

  def self.view_logs
    return puts "❌ Access Denied." unless Admin.validate

    if File.exist?(LOG_PATH)
      puts "\n📄 Secure Logs:\n-------------------------"
      puts decrypt(File.read(LOG_PATH))
    else
      puts "No logs found."
    end
  end
end
