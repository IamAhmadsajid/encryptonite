require_relative 'lib/admin'
require_relative 'lib/encryption'
require_relative 'lib/file_crypto'
require_relative 'lib/admin'
require_relative 'lib/logger'

unless File.exist?('admin.key')
  puts "\n🔐 Admin setup required."
  Admin.set_password
end


def password_strength(password)
  strength = 0
  strength += 1 if password.length >= 8
  strength += 1 if password.match(/[A-Z]/)
  strength += 1 if password.match(/[a-z]/)
  strength += 1 if password.match(/\d/)
  strength += 1 if password.match(/[\W_]/)

  case strength
  when 0..2 then "Weak"
  when 3 then "Moderate"
  when 4 then "Strong"
  else "Very Strong"
  end
end

def menu
  puts "\n📦 Welcome to Encryptonite Ruby AES Encryption CLI Tool"
  puts "1. Encrypt Text"
  puts "2. Decrypt Text"
  puts "3. Encrypt File"
  puts "4. Decrypt File"
  puts "5. Encrypt Folder"
  puts "6. Decrypt Folder"
  puts "7. View Logs (Admin Only)"
  puts "8. Exit"
  print "\nSelect an option: "
end

loop do
  menu
  choice = gets.chomp

  case choice
  when '1'
    print "\n🔑 Enter encryption key: "
    key = gets.chomp
    puts "Password strength: #{password_strength(key)}"
    print "\n📝 Enter message to encrypt: "
    message = gets.chomp
    encrypted = TextCrypto.encrypt(message, key)
    puts "\n✅ Encrypted Text:\n#{encrypted}"
    Logger.log("Text Encrypt", message[0..20])

  when '2'
    print "\n🔑 Enter decryption key: "
    key = gets.chomp
    print "\n🔐 Paste encrypted Base64 text: "
    encrypted = gets.chomp
    decrypted = TextCrypto.decrypt(encrypted, key)
    puts "\n🔓 Decrypted Text:\n#{decrypted}"
    Logger.log("Text Decrypt", encrypted[0..20])

  when '3'
    print "\n📄 Enter full file path to encrypt: "
    path = gets.chomp
    print "🔑 Enter encryption key: "
    key = gets.chomp
    puts "Password strength: #{password_strength(key)}"
    begin
      output = FileCrypto.encrypt_file(path, key)
      puts "\n✅ File encrypted and saved to: #{output}"
      Logger.log("File Encrypt", output)
    rescue => e
      puts e.message
    end

  when '4'
    print "\n📄 Enter full encrypted (.enc) file path: "
    path = gets.chomp
    print "🔑 Enter decryption key: "
    key = gets.chomp
    begin
      output = FileCrypto.decrypt_file(path, key)
      puts "\n🔓 File decrypted and saved to: #{output}"
      Logger.log("File Decrypt", output)
    rescue => e
      puts e.message
    end
  
  when '5'
  print "📁 Enter folder path to encrypt: "
  path = gets.chomp
  print "🔑 Enter encryption password: "
  key = STDIN.noecho(&:gets).chomp
  puts "\n⏳ Encrypting folder..."
  FileCrypto.encrypt_folder(path, key)
  puts "✅ Folder encrypted successfully."

when '6'
  print "📂 Enter folder path to decrypt: "
  path = gets.chomp
  print "🔑 Enter decryption password: "
  key = STDIN.noecho(&:gets).chomp
  puts "\n⏳ Decrypting folder..."
  FileCrypto.decrypt_folder(path, key)
  puts "✅ Folder decrypted successfully."
  
  
  when '7'
    Logger.view_logs
  

  when '8'
    puts "\n👋 Exiting. Logs saved in logs/activity.log.enc"
    break

  else
    puts "\n❌ Invalid option. Try again."
  end
end
