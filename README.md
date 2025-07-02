
# 🔐 Encryptonite

**Encryptonite** is a secure, modular, and user-friendly encryption tool written in Ruby. It enables you to encrypt and decrypt text, files, and entire folders using AES-256-CBC encryption, all through an interactive command-line interface with authentication and logging.

---

## 📁 Project Structure



Encryptonite/
├── Gemfile
├── README.md
├── main.rb
└── lib/
├── admin.rb
├── encryption.rb
├── file\_crypto.rb
└── logger.rb



## 🚀 Features

- 🔒 AES-256-CBC encryption for text, files, and folders
- 🧑‍💼 Admin setup with custom password (set on first run)
- 📁 Encrypt and decrypt any file or directory recursively
- ✨ Text encryption/decryption directly from CLI
- 📜 Logs all activities to a log file
- ✅ Password authentication for secure operations
- 💎 Clean Ruby modular architecture



## 💎 Technologies Used

- Ruby standard libraries: `openssl`, `base64`, `io/console`, `fileutils`
- Custom Ruby modules for encryption logic, file handling, folder traversal, and logging



## 📦 Installation

### Requirements

- Ruby 2.5+
- No external gems required

### Setup

1. Clone or download the repository:
   ```bash
   git clone https://github.com/yourname/encryptonite.git
   cd encryptonite
````

2. Run the program:

   ```bash
   ruby main.rb
   ```

---

## 🛠️ How It Works

### 1. First-Run Admin Password Setup

On your first run, the program will prompt you to create an **Admin password** securely (it is stored hashed or securely handled). You will use this password every time you start the program to authenticate.

```
Set admin password: ********
Confirm password: ********
```

Subsequent launches will prompt you to enter this password.

---

### 2. Main Menu

After logging in, you will see:

```
📦 Welcome to Encryptonite Ruby AES Encryption CLI Tool

1. Encrypt Text
2. Decrypt Text
3. Encrypt File
4. Decrypt File
5. Encrypt Folder
6. Decrypt Folder
7. View Logs (Admin Only)
8. Exit
```

---

### 3. Encryption and Decryption Processes

* **Encrypt Text / Decrypt Text:**

  * Input plaintext or Base64 string.
  * Provide an encryption password.
  * Output is displayed and can be saved.

* **Encrypt File / Decrypt File:**

  * Specify file path and output filename.
  * Enter an encryption password.
  * AES encryption applied with a unique IV per file.

* **Encrypt Folder / Decrypt Folder:**

  * Specify directory path.
  * All files in the directory are processed recursively.
  * Each file is encrypted/decrypted individually.

* **View Logs:**

  * Requires Admin authentication.
  * Displays the log entries with timestamps.

---

## 🧩 Modules Breakdown

### `main.rb`

* Provides the interactive CLI interface.
* Handles user input and calls methods from supporting modules.

### `lib/admin.rb`

* Prompts for Admin password creation on first use.
* Validates Admin password on subsequent runs.

### `lib/encryption.rb`

* Implements AES-256-CBC encryption and decryption logic.
* Generates and manages IVs per operation.
* Uses Base64 for encoded output.

### `lib/file_crypto.rb`

* Handles file and folder I/O.
* Integrates encryption for all files in a folder.
* Provides safe read/write operations.

### `lib/logger.rb`

* Records all encryption and decryption actions.
* Logs include timestamps and action details.

---

## 📋 Example Usage

### Encrypt Text

```
Enter text to encrypt: MySecret
Enter password: ********
Encrypted Text: Base64String...
```

### Decrypt Text

```
Enter text to decrypt: Base64String...
Enter password: ********
Decrypted Text: MySecret
```

### Encrypt a File

```
Enter file to encrypt: secret.docx
Enter output file name: secret.enc
Enter password: ********
File encrypted successfully.
```

### Decrypt a Folder

```
Enter folder to decrypt: EncryptedFiles
Enter output folder: DecryptedFiles
Enter password: ********
All files decrypted successfully.
```

---

## 🔐 Security Considerations

* Passwords are securely captured using `STDIN.noecho`.
* Each encryption generates a new Initialization Vector.
* Encrypted output is Base64 encoded.
* Logs are stored in `log.txt` for traceability.

---

## 📝 Logs

Every operation is recorded with timestamp and details.

Example log:

```
[2025-07-02 21:05:00] Encrypted folder: Documents -> DocumentsEncrypted
[2025-07-02 21:10:00] Decrypted file: secret.enc -> secret.txt
```

---

## 🙋‍♂️ Author

**Encryptonite** created by:
Ahmad \_
📧 [itxahmadhere@gmail.com](mailto:itxahmadhere@gmail.com)
📍 Pakistan

---

## 📄 License

This project is licensed under the MIT License.

