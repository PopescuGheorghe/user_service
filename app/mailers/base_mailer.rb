require 'mandrill'

class BaseMailer
  DIGI_EDU_MAIL = 'no-reply@digital-education.com'

  # Public - builds message hash to be used with mandirll send_template
  # params - parameters used to build hash
  # Returns hash
  def build_message(params)
    vars_params = params.except('email')
    vars = build_params(vars_params)
    email = params['email']

    {
      'merge_vars' => [{
        'vars' => vars,
        'rcpt' => email }],
      'to' => [{
        'type' => 'to',
        'email' => email
      }],
      'from_email' => DIGI_EDU_MAIL
    }
  end

  def build_content(params)
    build_params(params)
  end

  private

  def send_mail(template_name, template_content, message)
    mandrill = Mandrill::API.new(ENV['SMTP_PASSWORD'])
    mandrill.messages.send_template(template_name, template_content, message)
  end

  # Private - build hash used to match template variables
  # params- varaiables used in template
  # Returns hash
  def build_params(params)
    merge_vars = []
    params.each do |key, value|
      merge_vars << { 'content' => value, 'name' => key }
    end
    merge_vars
  end
end