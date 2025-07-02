require 'openssl'
require 'digest'
require 'fileutils'

class FileCrypto
  def self.encrypt_file(path, key)
    raise "File not found!" unless File.exist?(path)

    extension = File.extname(path)  # store original extension
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = Digest::SHA256.digest(key)
    iv = cipher.random_iv

    output_path = "#{path}.enc"

    File.open(output_path, 'wb') do |outf|
      outf.write(iv)
      outf.write("#{extension}\n")  # store extension on a line
      File.open(path, 'rb') do |inf|
        while chunk = inf.read(4096)
          outf.write(cipher.update(chunk))
        end
        outf.write(cipher.final)
      end
    end

    File.delete(path)  # delete original after encryption
    output_path
  end

  def self.decrypt_file(path, key)
    raise "File not found!" unless File.exist?(path)
    raise "Invalid file format. Only '.enc' supported." unless path.end_with?('.enc')

    decipher = OpenSSL::Cipher.new('AES-256-CBC')
    decipher.decrypt
    decipher.key = Digest::SHA256.digest(key)

    iv = nil
    original_ext = ''
    output_path = ''

    File.open(path, 'rb') do |inf|
      iv = inf.read(16)
      decipher.iv = iv

      # Read extension line (until newline)
      ext_line = ''
      while (char = inf.read(1))
        break if char == "\n"
        ext_line += char
      end
      original_ext = ext_line.strip
      base_name = File.basename(path, '.enc')
      output_path = "#{File.dirname(path)}/#{base_name}#{original_ext}"

      File.open(output_path, 'wb') do |outf|
        while chunk = inf.read(4096)
          outf.write(decipher.update(chunk))
        end
        outf.write(decipher.final)
      end
    end

    File.delete(path)  # delete .enc file after successful decryption
    output_path
  rescue => e
    "❌ ERROR: Failed to decrypt file. #{e.message}"
  end

  def self.encrypt_folder(folder_path, key)
    raise "Folder not found!" unless Dir.exist?(folder_path)

    Dir.glob("#{folder_path}/**/*").each do |file|
      next if File.directory?(file)
      next if file.end_with?('.enc')  # skip already encrypted files

      begin
        encrypted = encrypt_file(file, key)
        Logger.log("FOLDER ENCRYPT", "File: #{encrypted}")
      rescue => e
        Logger.log("ERROR", "Failed to encrypt #{file}: #{e.message}")
      end
    end
  end

  def self.decrypt_folder(folder_path, key)
    raise "Folder not found!" unless Dir.exist?(folder_path)

    Dir.glob("#{folder_path}/**/*.enc").each do |file|
      begin
        decrypted = decrypt_file(file, key)
        Logger.log("FOLDER DECRYPT", "File: #{decrypted}")
      rescue => e
        Logger.log("ERROR", "Failed to decrypt #{file}: #{e.message}")
      end
    end
  end
end
