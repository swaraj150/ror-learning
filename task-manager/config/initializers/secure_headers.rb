# config/initializers/secure_headers.rb
if Rails.env.test?
  SecureHeaders::Configuration.default do |config|
    config.x_frame_options    = SecureHeaders::OPT_OUT
    config.x_content_type_options = SecureHeaders::OPT_OUT
    config.x_xss_protection   = SecureHeaders::OPT_OUT
    config.referrer_policy    = SecureHeaders::OPT_OUT
    config.csp                = SecureHeaders::OPT_OUT
  end
else
  SecureHeaders::Configuration.default do |config|
    config.x_frame_options = "DENY"
    config.x_content_type_options = "nosniff"
    config.x_xss_protection = "1; mode=block"
    config.referrer_policy = "strict-origin-when-cross-origin"
    config.hsts = "max-age=#{1.year.to_i}; includeSubDomains" if Rails.env.production?
    config.csp = SecureHeaders::OPT_OUT
  end
end
