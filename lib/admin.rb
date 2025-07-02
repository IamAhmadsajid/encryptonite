require 'io/console'
require 'openssl'
require 'digest'
require 'base64'
require 'digest'
require 'fileutils'

class Admin
  KEY_FILE = 'admin.key'

  def self.set_password
    print "\n🔑 Set Admin Password: "
    pwd = STDIN.noecho(&:gets).chomp
    puts "\n✅ Admin password set."
    File.write(KEY_FILE, Digest::SHA256.hexdigest(pwd))
  end

  def self.validate
    return false unless File.exist?(KEY_FILE)
    print "\n🔐 Enter Admin Password: "
    input = STDIN.noecho(&:gets).chomp
    puts
    File.read(KEY_FILE).strip == Digest::SHA256.hexdigest(input)
  end
end
