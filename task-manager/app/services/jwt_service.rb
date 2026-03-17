class JwtService
  SECRET_KEY = Rails.application.secret_key_base
  ACCESS_EXPIRY     = 24.hours.to_i
  REFRESH_EXPIRY = 30.days.to_i

  def self.encode_access(payload)
    payload[:exp] = Time.now.to_i + ACCESS_EXPIRY
    payload[:type] = "access"
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.encode_refresh(payload)
    payload[:exp] = Time.now.to_i + REFRESH_EXPIRY
    payload[:type] = "refresh"
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
