module JwtHelper
  def auth_headers(user)
    token = JwtService.encode_access({ user_id: user.id })
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include JwtHelper, type: :request
end
