if Rails.env.test?
  Rack::Attack.enabled = false
else
  class Rack::Attack
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
      url: ENV.fetch("REDIS_URL", "redis://redis:6379/0")
    )


    # global limit — 300 requests per 5 minutes per IP
    throttle("req/ip", limit: 300, period: 5.minutes) do |req|
      req.ip
    end

    # login endpoint — 5 attempts per 20 seconds per IP
    throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
      req.ip if req.path == "/users/sign_in" && req.post?
    end

    # registration — 3 attempts per hour per IP
    throttle("signups/ip", limit: 3, period: 1.hour) do |req|
      req.ip if req.path == "/users" && req.post?
    end

    # authenticated users — 100 requests per minute per user
    throttle("req/user", limit: 100, period: 1.minute) do |req|
      req.env["warden"]&.user&.id
    end


    # block IPs that have too many 401s
    blocklist("block suspicious IPs") do |req|
      Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 10, findtime: 1.minute, bantime: 1.hour) do
        req.path == "/users/sign_in" && req.post?
      end
    end


    self.throttled_responder = lambda do |req|
      [
        429,
        { "Content-Type" => "application/json" },
        [ { error: "Too many requests. Please try again later." }.to_json ]
      ]
    end
  end
end
