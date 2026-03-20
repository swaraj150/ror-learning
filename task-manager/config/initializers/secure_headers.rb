SecureHeaders::Configuration.default do |config|
  # clickjacking protection
  config.x_frame_options = "DENY"

  # stop browsers from sniffing content type
  config.x_content_type_options = "nosniff"

  # XSS protection
  config.x_xss_protection = "1; mode=block"

  # only send referrer on same origin
  config.referrer_policy = "strict-origin-when-cross-origin"

  # HTTPS only — enable in production
  config.hsts = "max-age=#{1.year.to_i}; includeSubDomains" if Rails.env.production?

  # disable for API — CSP is for browsers rendering HTML
  config.csp = SecureHeaders::OPT_OUT
end
