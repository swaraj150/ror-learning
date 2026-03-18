class JwtService
  ACCESS_EXPIRY     = 24.hours.to_i
  REFRESH_EXPIRY = 30.days.to_i

  def self.secret_key
    Rails.application.secret_key_base
  end

  def self.encode_access(payload)
    payload[:exp] ||= Time.now.to_i + ACCESS_EXPIRY
    payload[:type] = "access"
    JWT.encode(payload, secret_key, "HS256")
  end

  def self.encode_refresh(payload)
    payload[:exp] = Time.now.to_i + REFRESH_EXPIRY
    payload[:type] = "refresh"
    JWT.encode(payload, secret_key, "HS256")
  end


  def self.decode(token)
    decoded = JWT.decode(token, secret_key, true, algorithm: "HS256")
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::ExpiredSignature
    raise UnauthorizedError.new("Your session has expired, please log in again")
  rescue JWT::DecodeError
    raise UnauthorizedError.new("Invalid token")
  end
end
