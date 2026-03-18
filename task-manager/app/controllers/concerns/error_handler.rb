module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError,                       with: :render_internal_server_error
    rescue_from ApplicationError,                    with: :render_application_error

    rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
    rescue_from ActiveRecord::RecordNotUnique,       with: :render_conflict

    rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
    rescue_from ActionController::UnpermittedParameters, with: :render_bad_request
  end

  private

  def render_application_error(error)
    render_error(
      status:  error.status,
      code:    error.code,
      message: error.message,
      details: error.details
    )
  end

  def render_not_found(error)
    resource = error.model&.humanize || "Resource"
    render_error(
      status:  :not_found,
      code:    "not_found",
      message: "#{resource} not found"
    )
  end

  def render_record_invalid(error)
    render_error(
      status:  :unprocessable_entity,
      code:    "validation_error",
      message: "Validation failed",
      details: format_record_errors(error.record)
    )
  end

  def render_conflict(error)
    render_error(
      status:  :conflict,
      code:    "conflict",
      message: "Resource already exists"
    )
  end

  def render_token_expired(error)
    render_error(
      status:  :unauthorized,
      code:    "token_expired",
      message: "Your session has expired, please log in again"
    )
  end

  def render_parameter_missing(error)
    render_error(
      status:  :bad_request,
      code:    "parameter_missing",
      message: "Required parameter missing: #{error.param}"
    )
  end

  def render_bad_request(error)
    render_error(
      status:  :bad_request,
      code:    "bad_request",
      message: error.message
    )
  end

  def render_internal_server_error(error)
    message = Rails.env.production? ? "An unexpected error occurred" : error.message

    # Always log the full error
    Rails.logger.error("[ERROR] #{error.class}: #{error.message}\n#{error.backtrace&.first(5)&.join("\n")}")

    render_error(
      status:  :internal_server_error,
      code:    "internal_server_error",
      message: message
    )
  end

  def render_error(status:, code:, message:, details: [])
    render json: {
      error: {
        code:    code,
        message: message,
        details: details
      }
    }, status: status
  end

  def format_record_errors(record)
    record.errors.map do |error|
      {
        field:        error.attribute,
        message:      error.message,
        full_message: error.full_message
      }
    end
  end
end
