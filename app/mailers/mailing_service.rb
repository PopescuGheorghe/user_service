class MailingService < BaseMailer
  WELCOME_PARAMS = [:email, :template_slug, :url]

  def perform_welcome(params)

    fail Api::BaseController::InvalidAPIRequest.new("Error params", 403) unless validate_params(WELCOME_PARAMS, params)
    user = User.find_by(email: params[:email])
    fail Api::BaseController::InvalidAPIRequest.new("Error user", 403) unless user.present?

    template_slug = params[:template_slug]

    template_params = params.except(:email, :template_slug)

    message_params = params.except(:template_slug)
    message = build_message(message_params)
    template_content = build_content(template_params)

    send_mail(template_slug, template_content, message)
  end

  private

  # Private - validates parameters sent to be used in template
  # template_params - parameters defined in template
  # call_params - parameters received from api call
  # Returns boolean
  def validate_params(template_params, call_params)
    template_params.all? { |k| call_params.key?(k) }
  end
end