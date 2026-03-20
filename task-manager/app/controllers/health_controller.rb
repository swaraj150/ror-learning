class HealthController < ApplicationController
  skip_before_action :authenticate_request!

  def show
    checks = {
      database: database_healthy?,
      redis:    redis_healthy?,
      # sidekiq:  sidekiq_healthy?
    }

    status = checks.values.all? ? :ok : :service_unavailable

    render json: {
      status:    status == :ok ? "healthy" : "unhealthy",
      timestamp: Time.current.iso8601,
      checks:    checks
    }, status: status
  end

  private

  def database_healthy?
    ActiveRecord::Base.connection.execute("SELECT 1")
    true
  rescue StandardError
    false
  end

  def redis_healthy?
    Redis.new(url: ENV.fetch("REDIS_URL")).ping == "PONG"
  rescue StandardError
    false
  end

  def sidekiq_healthy?
    require "sidekiq/api"
    Sidekiq::ProcessSet.new.size.positive?
  rescue StandardError
    false
  end
end
