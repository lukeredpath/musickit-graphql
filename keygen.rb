require 'jwt'

class MusicKitTokenGenerator
  def initialize(teamID:, keyID:)
    raise RuntimeError.new("TeamID cannot be nil") unless teamID
    raise RuntimeError.new("Key ID cannot be nil") unless keyID

    @teamID = teamID
    @keyID = keyID
  end

  def headers
    {
      "alg": 'ES256',
      "kid": @keyID      
    }
  end

  def payload
    {
      "iss": @teamID,
      "iat": Time.now.to_i,
      "exp": Time.now.to_i + (60 * 60 * 24)
    }
  end

  def generate_encoded(keyFile:)
    pem_file = `openssl pkcs8 -nocrypt -in #{keyFile}`
    private_key = OpenSSL::PKey::EC.new(pem_file)
    JWT.encode payload, private_key, 'ES256', headers
  end

  def decode(encoded_token, keyFile:)
    pem_file = `openssl pkcs8 -nocrypt -in #{keyFile}`
    private_key = OpenSSL::PKey::EC.new(pem_file)
    public_key = OpenSSL::PKey::EC.new private_key
    public_key.private_key = nil
    JWT.decode encoded_token, public_key, true, { algorithm: 'ES256' }
  end
end
