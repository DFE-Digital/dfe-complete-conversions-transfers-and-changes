# :nocov:
namespace :session do
  desc "Decrypt the session to show how cookie decoding is done"
  task decrypt: :environment do
    # see doc/auth-and-session-cookie.md
    # for notes
    def decrypt_cookie(cookie)
      # copied more or less from:
      # https://gist.github.com/wildjcrt/6359713fa770d277927051fdeb30ebbf?permalink_comment_id=4565360#gistcomment-4565360
      cookie = CGI.unescape(cookie)
      data, iv, auth_tag = cookie.split("--").map { |v| Base64.strict_decode64(v) }

      raise InvalidMessage if auth_tag.nil? || auth_tag.bytes.length != 16

      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      secret = OpenSSL::PKCS5.pbkdf2_hmac(
        Rails.application.secret_key_base,
        Rails.configuration.action_dispatch.authenticated_encrypted_cookie_salt,
        1000,
        cipher.key_len,
        Rails.configuration.active_support.hash_digest_class.new
      )

      # Setup cipher for decryption and add inputs
      cipher.decrypt
      cipher.key = secret
      cipher.iv = iv
      cipher.auth_tag = auth_tag
      cipher.auth_data = ""

      # Perform decryption
      cookie_payload = cipher.update(data)
      cookie_payload << cipher.final
      cookie_payload = JSON.parse(cookie_payload)

      JSON.parse(Base64.decode64(cookie_payload["_rails"]["message"]))
    end

    usage = "pass in the undecoded encrypted cookie (straight from browser)\n" \
            "as env var e.g. 'rake session:decrypt COOKIE=longstring' "

    cookie = ENV.fetch("COOKIE") { abort usage }

    puts decrypt_cookie(cookie)
  end
end
# :nocov:
