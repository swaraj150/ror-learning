module JwtHelper
  def auth_headers(user)
    token = token_for(user)
    { "Authorization" => "Bearer #{token}" }
  end
  def token_for(user)
    JwtService.encode_access({ user_id: user.id })
  end
end

RSpec.configure do |config|
  config.include JwtHelper, type: :request
end
