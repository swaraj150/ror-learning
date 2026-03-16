class JwtService
  SECRET_KEY = Rails.application.secret_key_base
  EXPIRY     = 24.hours.to_i

  def self.encode(payload)
    payload[:exp] = Time.now.to_i + EXPIRY
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::ExpiredSignature
    raise "Token has expired"
  rescue JWT::DecodeError
    raise "Invalid token"
  end
end
